from rest_framework import serializers

from apps.common.error_code import ErrorCode
from apps.common.exception import CustomException
from apps.department.models import Department
from apps.common.serializers import TrimmedCharField
from apps.user.serializers import UserCommonInfoSerializer

from apps.user_work.models import UserWork
from apps.common.constants import UserType


class DepartmentSerializer(serializers.ModelSerializer):
    manager = serializers.SerializerMethodField()
    number_employees = serializers.SerializerMethodField()

    class Meta:
        model = Department
        fields = ('id', 'name', 'branch_office', 'manager', 'number_employees')

    def get_manager(self, instance):
        manager = UserWork.objects.filter(department=instance, user_type=UserType.MANAGER.value).first()
        if not manager:
            return None
        serializer = UserCommonInfoSerializer(manager.user)
        return serializer.data

    def get_number_employees(self, instance):
        count = UserWork.objects.filter(department=instance, deleted_at__isnull=True)
        if not count:
            return 0
        return count.count()


class DepartmentCommonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Department
        fields = ('id', 'name')


class CreateDepartmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Department
        fields = ('name', 'branch_office')

    def create(self, validated_data):
        is_exist = Department.objects.filter(name=validated_data.get('name'),
                                             branch_office=validated_data.get('branch_office'),
                                             deleted_at__isnull=True).first()
        if is_exist:
            raise CustomException(ErrorCode.error_client, custom_message='Tên phòng ban đã tồn tại trong chi nhánh')
        else:
            return super().create(validated_data)

    def update(self, instance, validated_data):
        is_exist = Department.objects.filter(name=validated_data.get('name'),
                                             branch_office=instance.branch_office,
                                             deleted_at__isnull=True).first()
        if is_exist and is_exist.id != instance.id:
            raise CustomException(ErrorCode.error_client, custom_message='Tên phòng ban đã tồn tại trong chi nhánh')
        else:
            instance.name = validated_data.get('name')
            instance.save()
            return instance
