import datetime

from rest_framework import serializers
from django.conf import settings

from apps.common.constants import UserType, ContractStatus, TicketStatus
from apps.common.exception import CustomException
from apps.contract.models import ContractType, Contract
from apps.common.error_code import ErrorCode
from apps.user.serializers import UserSerializer
from apps.user_work.models import UserWork
from apps.common.utils import *


class ContractSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    creator = UserSerializer()
    # approve = UserSerializer()

    class Meta:
        model = Contract
        fields = (
            'id', 'organization', 'user', 'approve', 'creator', 'contract_code',
            'basic_salary', 'salary_coefficient', 'name', 'state', 'status', 'start_date',
            'end_date', 'sign_date', 'contract_type', 'created_at', 'updated_at')
        extra_kwargs = {
            'created_at': {'format': settings.DATE_TIME_FORMATS[0]},
            'updated_at': {'format': settings.DATE_TIME_FORMATS[0]},
            'start_date': {'format': settings.DATE_FORMATS[0]},
            'end_date': {'format': settings.DATE_FORMATS[0]},
            'sign_date': {'format': settings.DATE_FORMATS[0]},
        }


class CreateContractSerializer(serializers.ModelSerializer):
    class Meta:
        model = Contract
        fields = (
            'user', 'contract_code', 'basic_salary', 'salary_coefficient',
            'name', 'start_date', 'end_date', 'sign_date',
            'contract_type')

    def validate(self, attrs):

        start_date = attrs.get('start_date', None)
        end_date = attrs.get('end_date', None)
        contract_type = attrs.get('contract_type', None)
        user_request = self.context.get('request').user
        attrs['creator'] = user_request
        user = attrs.get('user')

        if user_request.user_type >= user.user_type:
            raise CustomException(ErrorCode.error_not_permisstion)
        if user_request.user_type >= UserType.MANAGER.value:
            raise CustomException(ErrorCode.error_not_permisstion)
        if user_request.user_type == UserType.ADMIN.value:
            attrs['organization'] = UserWork.objects.filter(user=user, deleted_at__isnull=True).first().organization
        else:
            check_user_under_management(user_request, user)
            attrs['organization'] = UserWork.objects.filter(user=user_request,
                                                            deleted_at__isnull=True).first().organization

        if not contract_type and contract_type != 0:
            raise CustomException(ErrorCode.error_json_parser,
                                  custom_message='contract type is required')
        if contract_type != ContractType.INDEFINITE_TERM_LABOR_CONTRACT.value:
            if not end_date:
                raise CustomException(ErrorCode.error_json_parser,
                                      custom_message='The end date is required for this contract type')
            if start_date >= end_date:
                raise CustomException(ErrorCode.error_json_parser,
                                      custom_message='The end date must be greater than the start date')
            duration = (end_date - start_date).days
            print(f'duration: {duration}')
            if duration < 60:
                raise CustomException(ErrorCode.error_json_parser,
                                      custom_message='The contract must last for at least 2 months')
            if contract_type == ContractType.SEASONAL_CONTRACT.value and duration >= 365:
                raise CustomException(ErrorCode.error_json_parser,
                                      custom_message=f'The {ContractType.SEASONAL_CONTRACT.label} lasts less than 12 months')
            elif contract_type == ContractType.FIXED_TERM_LABOR_CONTRACT.value and not (
                    duration >= 365 and duration <= 1095):
                raise CustomException(ErrorCode.error_json_parser,
                                      custom_message='Labor contract with term from 12 months to 36 months')
        else:
            attrs['end_date'] = None

        is_exist = Contract.objects.filter(organization=attrs.get('organization'),
                                           contract_code=attrs.get('contract_code'), deleted_at__isnull=True,
                                           status=TicketStatus.APPROVED.value).first()
        if is_exist:
            raise CustomException(ErrorCode.error_json_parser,
                                  custom_message='This contract code is the code of another contract')
        is_exist = Contract.objects.filter(organization=attrs.get('organization'), user=attrs.get('user'),
                                           deleted_at__isnull=True, status=TicketStatus.APPROVED.value).order_by('-id')
        if is_exist.count() > 0:
            is_exist = is_exist.filter(state=ContractStatus.VALID_CONTRACT.value).first()
            if is_exist and start_date <= is_exist.end_date:
                raise CustomException(ErrorCode.error_json_parser,
                                      custom_message=f'The labor contract is still valid until the end of {is_exist.end_date.strftime(settings.DATE_FORMATS[0])}')
        return attrs

    def create(self, validated_data):
        print('go heeeeeee')
        if self.context.get('request').user.user_type <= UserType.CEO.value:
            validated_data['status'] = TicketStatus.APPROVED.value
            validated_data['state'] = ContractStatus.VALID_CONTRACT.value
            validated_data['approve'] = self.context.get('request').user
        else:
            validated_data['status'] = TicketStatus.PENDING.value
            validated_data['state'] = ContractStatus.INVALID_CONTRACT.value
        return super().create(validated_data)


class UpdateContractSerializer(serializers.ModelSerializer):
    class Meta:
        model = Contract
        fields = (
            'contract_code', 'basic_salary', 'salary_coefficient',
            'name', 'status', 'start_date', 'end_date', 'sign_date',
            'contract_type')

    def validate(self, attrs):
        # view = self.context.get('request')
        # print(self.instance)
        # print('\n')
        object = self.instance
        user_request = self.context.get('request').user
        user = object.user

        state = attrs.get('state', None)
        if user_request.user_type >= user.user_type:
            raise CustomException(ErrorCode.error_not_permisstion)
        check_user_under_management(user_request, user)
        if user_request.user_type >= UserType.MANAGER.value:
            raise CustomException(ErrorCode.error_not_permisstion)

        if user_request.user_type == UserType.DIRECTOR.value:
            if object.status == TicketStatus.APPROVED.value:

                if object.state == ContractStatus.EXPIRED_CONTRACT.value:
                    if state == ContractStatus.LIQUIDATION_CONTRACT.value:
                        attrs = {'state': ContractStatus.LIQUIDATION_CONTRACT.value}
                        return attrs
                    else:
                        raise CustomException(ErrorCode.error_json_parser,
                                              custom_message='Hợp đồng đã hết hạn, không thể chỉnh sửa')
                else:
                    if object.state == ContractStatus.VALID_CONTRACT.value:

                        raise CustomException(ErrorCode.error_json_parser,
                                              custom_message='Hợp đồng đã được phê duệt bởi Tổng giám đốc và đang có hiệu lực, bạn không thể chỉnh sửa thêm thông tin')
                    elif object.state != ContractStatus.INVALID_CONTRACT.value:
                        raise CustomException(ErrorCode.error_json_parser,
                                              custom_message='Hợp đồng đã hết hạn hoặc đã được thanh lý')

            else:
                attrs.pop('state')
                attrs.pop('status')
        start_date = attrs.get('start_date', object.start_date)
        end_date = attrs.get('end_date', object.end_date)
        contract_type = attrs.get('contract_type', object.contract_type)
        if contract_type != ContractType.INDEFINITE_TERM_LABOR_CONTRACT.value:
            if not end_date:
                raise CustomException(ErrorCode.error_json_parser,
                                      custom_message='The end date is required')
            if start_date >= end_date:
                raise CustomException(ErrorCode.error_json_parser,
                                      custom_message='The end date must be greater than the start date')
            duration = (end_date - start_date).days
            if duration < 60:
                raise CustomException(ErrorCode.error_json_parser,
                                      custom_message='The contract must last for at least 2 months')

            if contract_type == ContractType.SEASONAL_CONTRACT.value and duration >= 365:
                raise CustomException(ErrorCode.error_json_parser,
                                      custom_message=f'The {ContractType.SEASONAL_CONTRACT.label} lasts less than 12 months')
            if contract_type == ContractType.FIXED_TERM_LABOR_CONTRACT.value and not (
                    duration >= 365 and duration <= 1095):
                raise CustomException(ErrorCode.error_json_parser,
                                      custom_message='Labor contract with term from 12 months to 36 months')
        else:
            attrs['end_date'] = None

        is_exist = Contract.objects.filter(organization=object.organization,
                                           contract_code=attrs.get('contract_code', object.contract_code),
                                           deleted_at__isnull=True, status=TicketStatus.APPROVED.value).first()
        if is_exist and is_exist.id != object.id:
            raise CustomException(ErrorCode.error_json_parser,
                                  custom_message='This contract code is another employee\'s contract')

        is_exist = Contract.objects.filter(organization=object.organization, user=object.user, deleted_at__isnull=True,
                                           status=TicketStatus.APPROVED.value).order_by('-id')
        if is_exist.count() > 0:
            is_exist = is_exist.filter(state=ContractStatus.VALID_CONTRACT.value).first()
            if is_exist and is_exist.id != object.id and start_date <= is_exist.end_date:
                raise CustomException(ErrorCode.error_json_parser,
                                      custom_message=f'The labor contract is still valid until the end of {is_exist.end_date.strftime(settings.DATE_FORMATS[0])}')
        return attrs

    def update(self, instance, validated_data):
        status = validated_data.get('status')
        # object = self.get_object()
        # userType = self.context.get('request').user
        if status and status == TicketStatus.APPROVED.value:
            validated_data['state'] = ContractStatus.INVALID_CONTRACT.value
        return super().update(instance, validated_data)
