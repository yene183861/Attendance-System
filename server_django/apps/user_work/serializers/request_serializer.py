from rest_framework import serializers

from apps.common.error_code import ErrorCode
from apps.common.exception import CustomException
from apps.common.utils import is_valid_work
from apps.organization.models import Organization

from apps.user_work.models import UserWork
from apps.common.constants import UserType, WorkStatus


class CreateUserWorkSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserWork
        fields = (
            'organization', 'branch_office', 'department', 'team', 'position', 'work_status', 'reason', 'user',
            'user_type')
        extra_kwargs = {
            'user': {'read_only': True},
        }

    def validate(self, attrs):
        user_type = attrs.get('user_type')
        organization = attrs.get('organization', None)
        if not organization:
            raise CustomException(ErrorCode.error_json_parser, custom_message='organization is required')

        branch_office = attrs.get('branch_office', None)
        department = attrs.get('department', None)
        team = attrs.get('team', None)
        if user_type >= UserType.DIRECTOR.value:
            if not branch_office:
                raise CustomException(ErrorCode.error_json_parser, custom_message='branch_office is required')
            if user_type == UserType.DIRECTOR.value:
                attrs['department'] = None
                attrs['team'] = None
                work = UserWork.objects.filter(branch_office=branch_office,user_type=user_type, work_status=WorkStatus.WORKING.value).first()
                if work:
                    raise CustomException(ErrorCode.error_json_parser, custom_message='Each branch is managed by only one director')
            else:
                if not department:
                    raise CustomException(ErrorCode.error_json_parser, custom_message='department is required')

                if user_type == UserType.MANAGER.value:
                    attrs['team'] = None
                    work = UserWork.objects.filter(department=department, user_type=user_type,
                                                   work_status=WorkStatus.WORKING.value).first()
                    if work:
                        raise CustomException(ErrorCode.error_json_parser,
                                              custom_message='Each department is managed by only one manager')
                else:
                    if not team:
                        raise CustomException(ErrorCode.error_json_parser, custom_message='team is required')
                    if user_type == UserType.LEADER.value:
                        work = UserWork.objects.filter(team=team, user_type=user_type,
                                                       work_status=WorkStatus.WORKING.value).first()
                        if work:
                            raise CustomException(ErrorCode.error_json_parser,
                                              custom_message='Each team is managed by only one leader')

            is_not_valid = is_valid_work(attrs, organization, user_type)
            if is_not_valid:

                raise CustomException(ErrorCode.error_json_parser, custom_message=is_not_valid)
        else:
            attrs['branch_office'] = None
            attrs['department'] = None
            attrs['team'] = None
        work_status = attrs.get('work_status', None)
        reason = attrs.get('reason', None)
        if work_status is not None and work_status != WorkStatus.WORKING.value:
            if reason is None or len(reason) == 0:
                raise CustomException(ErrorCode.error_json_parser, custom_message=f'reason is required with work_status is not {WorkStatus.WORKING.label}')
        else:
            attrs['reason'] = None
        position = attrs.get('position', None)
        if position is None or len(position) == 0:
            attrs['position'] = UserType(user_type).label
        return attrs

    def create(self, validated_data):
        # user_type = validated_data.get('user_type')
        #
        # print(user_type)
        # is_exist = UserWork.objects.filter()
        user_work = UserWork.objects.create(**validated_data)
        return user_work

    def update(self, instance, validated_data):
        return super().update(instance, validated_data)


class UpdateUserWorkSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserWork
        fields = ('branch_office', 'department', 'team', 'position', 'work_status', 'reason', 'user_type')

    def validate(self, attrs):
        instance = self.context.get('view').get_object()
        print(instance)
        print('\n')
        organization = instance.organization

        user_request = self.context.get('request').user

        branch_office = attrs.get('branch_office', None)
        department = attrs.get('department', None)
        team = attrs.get('team', None)
        user_type = attrs.get('user_type', None)
        if user_type <= user_request.user_type:
            raise CustomException(ErrorCode.error_not_permisstion)
        if user_type >= UserType.LEADER.value:
            if not team:
                raise CustomException(ErrorCode.error_json_parser, custom_message='team is required')
            else:
                UserWork.objects.filter(user=user_request).first()

        if user_type is not None and user_type >= UserType.DIRECTOR.value:
            if not branch_office:
                raise CustomException(ErrorCode.error_json_parser, custom_message='branch_office is required')
            if user_type >= UserType.MANAGER.value:
                if not department:
                    raise CustomException(ErrorCode.error_json_parser, custom_message='department is required')
            if user_type >= UserType.LEADER.value:
                if not team:
                    raise CustomException(ErrorCode.error_json_parser, custom_message='team is required')
            is_not_valid = is_valid_work(attrs, organization, user_type)
            if is_not_valid:
                return CustomException(ErrorCode.error_json_parser, custom_message=is_not_valid)
        print(attrs)
        print('done')

        user_type = attrs.get('user_type')
        organization = attrs.get('organization', None)
        if not organization:
            raise CustomException(ErrorCode.error_json_parser, custom_message='organization is required')



        # if user_type >= UserType.DIRECTOR.value:
        #     if not branch_office:
        #         raise CustomException(ErrorCode.error_json_parser, custom_message='branch_office is required')
        #     if user_type == UserType.DIRECTOR.value:
        #         attrs['department'] = None
        #         attrs['team'] = None
        #         work = UserWork.objects.filter(branch_office=branch_office, user_type=user_type,
        #                                        work_status=WorkStatus.WORKING.value).first()
        #         if work:
        #             raise CustomException(ErrorCode.error_json_parser,
        #                                   custom_message='Each branch is managed by only one director')
        #     else:
        #         if not department:
        #             raise CustomException(ErrorCode.error_json_parser, custom_message='department is required')
        #
        #         if user_type == UserType.MANAGER.value:
        #             attrs['team'] = None
        #             work = UserWork.objects.filter(department=department, user_type=user_type,
        #                                            work_status=WorkStatus.WORKING.value).first()
        #             if work:
        #                 raise CustomException(ErrorCode.error_json_parser,
        #                                       custom_message='Each department is managed by only one manager')
        #         else:
        #             if not team:
        #                 raise CustomException(ErrorCode.error_json_parser, custom_message='team is required')
        #             if user_type == UserType.LEADER.value:
        #                 work = UserWork.objects.filter(team=team, user_type=user_type,
        #                                                work_status=WorkStatus.WORKING.value).first()
        #                 if work:
        #                     raise CustomException(ErrorCode.error_json_parser,
        #                                           custom_message='Each team is managed by only one leader')
        #
        #     is_not_valid = is_valid_work(attrs, organization, user_type)
        #     if is_not_valid:
        #         raise CustomException(ErrorCode.error_json_parser, custom_message=is_not_valid)
        # else:
        #     attrs['branch_office'] = None
        #     attrs['department'] = None
        #     attrs['team'] = None
        # work_status = attrs.get('work_status', None)
        # reason = attrs.get('reason', None)
        # if work_status is not None and work_status != WorkStatus.WORKING.value:
        #     if reason is None or len(reason) == 0:
        #         raise CustomException(ErrorCode.error_json_parser,
        #                               custom_message=f'reason is required with work_status is not {WorkStatus.WORKING.label}')
        # else:
        #     attrs['reason'] = None
        # position = attrs.get('position', None)
        # if position is None or len(position) == 0:
        #     attrs['position'] = UserType(user_type).label
        return attrs

    def update(self, instance, validated_data):
        user = instance.user
        user.user_type = validated_data.get('user_type')
        user.save()

        return super().update(instance, validated_data)
