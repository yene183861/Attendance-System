from rest_framework import serializers
from apps.allowance.models import Allowance
from apps.common.exception import CustomException
from apps.common.error_code import ErrorCode


class AllowanceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Allowance
        fields = ('id', 'organization', 'name', 'description', 'amount', 'maximum_amount', 'by_time')


class CreateAllowanceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Allowance
        fields = ('organization', 'name', 'description', 'amount', 'maximum_amount', 'by_time')

    def validate(self, attrs):
        name = attrs.get('name', None)
        if not name or len(name) == 0:
            raise CustomException(ErrorCode.error_client, custom_message='name is required')
        amount = attrs.get('amount', None)
        maximum_amount = attrs.get('maximum_amount', None)
        if not amount:
            raise CustomException(ErrorCode.error_client, custom_message='amount is required')
        if amount <= 0:
            raise CustomException(ErrorCode.error_client, custom_message='Số tiền phụ cấp phải lớn hơn 0')
        if maximum_amount < amount:
            raise CustomException(ErrorCode.error_client, custom_message='Số tiền tối đa phải lớn hơn hoặc bằng số tiền phụ cấp')
        return attrs

    def create(self, validated_data):
        is_exist = Allowance.objects.filter(name=validated_data.get('name'), deleted_at__isnull=True).first()
        if is_exist:
            raise CustomException(ErrorCode.error_client, custom_message='Allowance is exist with name')
        allowance = Allowance.objects.create(**validated_data)
        return allowance

    def update(self, instance, validated_data):
        validated_data.pop('organization')
        is_exist = Allowance.objects.filter(name=validated_data.get('name'), deleted_at__isnull=True).first()
        if is_exist and is_exist.id != instance.id:
            raise CustomException(ErrorCode.error_client, custom_message='Allowance is exist with name')
        return super().update(instance, validated_data)
