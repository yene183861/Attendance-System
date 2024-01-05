import datetime

from django.conf import settings
from rest_framework import serializers
from apps.common.error_code import ErrorCode
from apps.common.exception import CustomException

from apps.user.serializers import UserCommonInfoSerializer

from apps.common.utils import check_user_under_management, get_last_date_of_month


from apps.reward_and_discipline.models import RewardOrDiscipline


class RewardAndDisciplineSerializer(serializers.ModelSerializer):
    user = UserCommonInfoSerializer()

    class Meta:
        model = RewardOrDiscipline
        fields = ('id', 'user', 'month', 'title', 'content', 'amount', 'is_reward', 'created_at', 'updated_at')
        extra_kwargs = {
            'month': {'format': settings.DATE_FORMATS[0]},
            'created_at': {'format': settings.DATE_TIME_FORMATS[0]},
            'updated_at': {'format': settings.DATE_TIME_FORMATS[0]},
        }


class CreateRewardAndDisciplineSerializer(serializers.ModelSerializer):
    class Meta:
        model = RewardOrDiscipline
        fields = ('user', 'month', 'title', 'content', 'amount', 'is_reward')

    def validate(self, attrs):
        user = attrs.get('user')
        user_request = self.context.get('request').user
        if user.user_type < user_request.user_type:
            raise CustomException(ErrorCode.error_not_permisstion)
        print('go 123')
        check_user_under_management(user_request, user)
        print('go 1233333')
        month = attrs.get('month')
        month = get_last_date_of_month(month)
        attrs['month'] = month

        amount = attrs.get('amount')
        if amount < 0:
            raise CustomException(ErrorCode.error_client, custom_message='amount must be positive')
        return attrs

    def create(self, validated_data):
        o = RewardOrDiscipline.objects.create(**validated_data)
        return o


class UpdateRewardAndDisciplineSerializer(serializers.ModelSerializer):
    class Meta:
        model = RewardOrDiscipline
        fields = ('user', 'title', 'content', 'amount', 'is_reward', 'month')

    def validate(self, attrs):
        instance = self.context.get('view').get_object()
        new_month = attrs.get('month', None)
        if new_month:
            new_month = get_last_date_of_month(new_month)
        month = instance.month
        now = get_last_date_of_month(datetime.datetime.now().date())
        if month <= now and (now - month).days > 5:
            raise CustomException(ErrorCode.error_client, custom_message='Last month\'s payroll is closed on the 5th of this month, cannot be edited')
        if new_month < now and (month - new_month).days > 5:
            raise CustomException(ErrorCode.error_client,
                                  custom_message='This month\'s payroll is closed, cannot be edited')
        amount = attrs.get('amount',instance.amount)

        if amount < 0:
            raise CustomException(ErrorCode.error_client, custom_message='amount must be positive')
        return attrs

    def update(self, instance, validated_data):
        print(validated_data.get('user'))
        print(instance.user)
        print(validated_data)
        t = super().update(instance, validated_data)
        print(t.user)
        return t
