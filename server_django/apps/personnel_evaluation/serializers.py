import datetime

from django.conf import settings
from rest_framework import serializers

from apps.common.error_code import ErrorCode
from apps.common.exception import CustomException
from apps.common.utils import get_last_date_of_month
from apps.common.constants import UserType

from apps.user_work.models import UserWork

from apps.personnel_evaluation.models import PersonnelEvaluation

from apps.user.serializers import UserCommonInfoSerializer


class PersonnelEvaluationSerializer(serializers.ModelSerializer):
    user = UserCommonInfoSerializer()
    reviewer = UserCommonInfoSerializer()

    class Meta:
        model = PersonnelEvaluation

        fields = (
            'id', 'user', 'status', 'month', 'completed_before_deadline', 'completed_on_time', 'completed_overdue',
            'unfinished', 'reviewer', 'reviewer_comment', 'self_assessment', 'created_at', 'updated_at')
        extra_kwargs = {
            'month': {'format': settings.DATE_FORMATS[0]},
            'created_at': {'format': settings.DATE_TIME_FORMATS[0]},
            'updated_at': {'format': settings.DATE_TIME_FORMATS[0]},
        }


class CreatePersonnelEvaluationSerializer(serializers.ModelSerializer):
    class Meta:
        model = PersonnelEvaluation
        fields = (
            'user', 'month', 'completed_before_deadline', 'completed_on_time', 'completed_overdue',
            'unfinished', 'reviewer_comment', 'self_assessment', 'status')

    def validate(self, attrs):
        # user = attrs.get('user')
        # user_request = self.context.get('request').user
        # if user != user_request:
        #     if user.user_type < user_request.user_type:
        #         raise CustomException(ErrorCode.error_not_permisstion)
        #     else:
        #         if user_request.user_type != UserType.ADMIN.value:
        #
        #             user_work = UserWork.objects.filter(user=user, deleted_at__isnull=True).first()
        #             user_request_work = UserWork.objects.filter(user=user_request, deleted_at__isnull=True).first()
        #
        #             if user_work.organization != user_request_work.organization:
        #                 raise CustomException(ErrorCode.error_not_permisstion)
        #
        #             branch = user_request_work.branch_office
        #             if branch and user_work.branch_office != branch:
        #                 raise CustomException(ErrorCode.error_not_permisstion)
        #
        #             department = user_request_work.department
        #             if department and user_work.department != department:
        #                 raise CustomException(ErrorCode.error_not_permisstion)
        #
        #             team = user_request_work.team
        #             if team and user_work.team != team:
        #                 raise CustomException(ErrorCode.error_not_permisstion)
        #     # attrs['status'] = True
        #     # attrs['self_assessment'] = None
        #     # if not attrs.get('reviewer_comment', None):
        #     #     raise CustomException(ErrorCode.error_client, custom_message='reviewer_comment is required')
        #     # attrs['reviewer'] = user_request
        #
        # else:
        #     # attrs['status'] = False
        #     # if not attrs.get('self_assessment', None):
        #     #     raise CustomException(ErrorCode.error_client, custom_message='self_assessment is required')
        #
        # month = attrs.get('month')
        # now = datetime.datetime.now().date()
        # month = get_last_date_of_month(month)
        # if month > now:
        #     raise CustomException(ErrorCode.error_json_parser,
        #                           custom_message='There is no deadline for self-assessment and personnel evaluation')
        # is_exist = PersonnelEvaluation.objects.filter(user=user, month=month, deleted_at__isnull=True).first()
        # if is_exist:
        #     format_month = month.strftime(settings.MONTH_FORMATS[0])
        #     raise CustomException(ErrorCode.error_client,
        #                           custom_message=f'user was personally rated for the month {format_month}')
        # attrs['month'] = month
        # completed_before_deadline = attrs.get('completed_before_deadline', 0)
        # completed_on_time = attrs.get('completed_on_time', 0)
        # completed_overdue = attrs.get('completed_overdue', 0)
        # unfinished = attrs.get('unfinished', 0)
        # _sum = completed_before_deadline + completed_on_time + completed_overdue + unfinished
        # if _sum != 100:
        #     raise CustomException(ErrorCode.error_json_parser, custom_message='Invalid evaluation criteria')
        return attrs

    def create(self, validated_data):
        evaluation = PersonnelEvaluation.objects.create(**validated_data)
        return evaluation


class UpdatePersonnelEvaluationSerializer(CreatePersonnelEvaluationSerializer):
    class Meta:
        model = PersonnelEvaluation
        fields = (
            'completed_before_deadline', 'completed_on_time', 'completed_overdue', 'unfinished',
            'reviewer_comment', 'reviewer_comment', 'self_assessment')

    def validate(self, attrs):
        # instance = self.context.get('view').get_object()
        # request = self.context.get('request', None)
        # user_request = request.user
        # if instance.user.user_type == user_request.user_type:
        #     if not instance.status:
        #         raise CustomException(ErrorCode.error_client,
        #                               custom_message='Your personnel evaluation sheet has been locked by your superiors and cannot be edited')
        #     attrs.pop('reviewer_comment')
        # else:
        #     attrs.pop('self_assessment')
        # completed_before_deadline = attrs.get('completed_before_deadline', instance.completed_before_deadline)
        # completed_on_time = attrs.get('completed_on_time', instance.completed_on_time)
        # completed_overdue = attrs.get('completed_overdue', instance.completed_overdue)
        # unfinished = attrs.get('unfinished', instance.unfinished)
        # _sum = completed_before_deadline + completed_on_time + completed_overdue + unfinished
        # if _sum != 100:
        #     raise CustomException(ErrorCode.error_json_parser, custom_message='Invalid evaluation criteria')
        return

    def update(self, instance, validated_data):
        return super().update(instance, validated_data)
