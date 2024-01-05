from rest_framework import serializers

from apps.team.models import Team
from apps.user.serializers import UserCommonInfoSerializer
from apps.common.error_code import ErrorCode
from apps.common.exception import CustomException
from apps.user_work.models import UserWork
from apps.common.constants import UserType


class TeamSerializer(serializers.ModelSerializer):
    leader = serializers.SerializerMethodField()
    number_employees = serializers.SerializerMethodField()

    class Meta:
        model = Team
        fields = ('id', 'name', 'department', 'leader', 'number_employees')

    def get_leader(self, instance):
        leader = UserWork.objects.filter(team=instance, user_type=UserType.LEADER.value, deleted_at__isnull=True).first()
        if not leader:
            return None
        serializer = UserCommonInfoSerializer(leader.user)
        return serializer.data

    def get_number_employees(self, instance):
        count = UserWork.objects.filter(team=instance, deleted_at__isnull=True)
        if not count:
            return 0
        return count.count()


class TeamCommonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Team
        fields = ('id', 'name', 'department')


class CreateTeamSerializer(serializers.ModelSerializer):
    class Meta:
        model = Team
        fields = ('name', 'department')
    
    def create(self, validated_data):
        name = validated_data.get('name')
        department = validated_data.get('department')
        is_exist = Team.objects.filter(name=name, department=department, deleted_at__isnull=True).first()
        if is_exist:
            raise CustomException(ErrorCode.error_client, custom_message='Team đã tồn tại trong phòng ban này.')
        else:
            return super().create(validated_data)
        
    def update(self, instance, validated_data):
        department = instance.department
        name = validated_data.get('name')
        is_exist = Team.objects.filter(name=name, department=department, deleted_at__isnull=True).first()
        if is_exist and is_exist.id != instance.id:
            raise CustomException(ErrorCode.error_client, custom_message='Team đã tồn tại trong phòng ban này.\nVui lòng nhập tên khác.')
        else:
            return super().update(instance, validated_data)


