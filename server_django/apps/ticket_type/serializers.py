
from rest_framework import serializers

from apps.common.constants import UserType
from apps.ticket_type.models import TicketReason
from apps.common.error_code import ErrorCode
from apps.common.exception import CustomException
from apps.user_work.models import UserWork


class TicketReasonSerializer(serializers.ModelSerializer):
    class Meta:
        model = TicketReason
        fields = (
            'id', 'organization', 'name', 'ticket_type', 'is_work_calculation', 'description', 'maximum', 'by_time',
        )


# class TicketReasonCommonSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = TicketReason
#         fields = ('id', 'organization', 'name', 'is_work_calculation', 'is_punish_money')


class CreateTicketReasonSerializer(serializers.ModelSerializer):
    class Meta:
        model = TicketReason
        fields = ('organization', 'name', 'ticket_type', 'is_work_calculation', 'description', 'maximum', 'by_time'
                  )

    def validate(self, attrs):
        user_request = self.context.get('request').user
        org = attrs.get('organization')
        ticket_type = attrs.get('ticket_type')
        name = attrs.get('name')
        if user_request.user_type != UserType.ADMIN.value:
            user_work = UserWork.objects.filter(user=user_request, organization=org, deleted_at__isnull=True).first()
            if not user_work:
                raise CustomException(ErrorCode.error_not_permisstion)

        unique = TicketReason.objects.filter(organization=org, ticket_type=ticket_type, name=name,
                                             deleted_at__isnull=True).first()
        if unique:
            raise CustomException(ErrorCode.error_client,
                                  custom_message='TicketReason already exists in the organization')
        return attrs

    def create(self, validated_data):
        ticket_reason = TicketReason.objects.create(**validated_data)
        return ticket_reason


class UpdateTicketReasonSerializer(serializers.ModelSerializer):
    class Meta:
        model = TicketReason
        fields = ('name', 'is_work_calculation', 'description', 'maximum', 'by_time')

    def validate(self, attrs):
        instance = self.context.get('view').get_object()
        name = attrs.get('name')
        unique = TicketReason.objects.filter(organization=instance.organization, ticket_type=instance.ticket_type,
                                             name=name, deleted_at__isnull=True).first()
        if unique and unique.id != instance.id:
            raise CustomException(ErrorCode.error_client,
                                  custom_message='TicketReason with name already exists in the organization')
        return attrs

    def update(self, instance, validated_data):
        return super().update(instance, validated_data)
