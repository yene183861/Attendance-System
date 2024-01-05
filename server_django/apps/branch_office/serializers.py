from rest_framework import serializers

from apps.common.constants import UserType

from apps.branch_office.models import BranchOffice
from apps.user_work.models import UserWork

from apps.user.serializers import UserCommonInfoSerializer


class BranchOfficeSerializer(serializers.ModelSerializer):
    director = serializers.SerializerMethodField()
    number_employees = serializers.SerializerMethodField()

    class Meta:
        model = BranchOffice
        fields = (
            'id', 'name', 'phone_number', 'address', 'short_description', 'tax_number', 'organization', 'director',
            'number_employees')

    def get_director(self, instance):
        director = UserWork.objects.filter(branch_office=instance, user_type=UserType.DIRECTOR.value).first()
        if not director:
            return None
        serializer = UserCommonInfoSerializer(director.user)
        return serializer.data

    def get_number_employees(self, instance):
        count = UserWork.objects.filter(branch_office=instance, deleted_at__isnull=True)
        print(count)
        if not count:
            return 0
        return count.count()

class BranchOfficeCommonSerializer(serializers.ModelSerializer):
    class Meta:
        model = BranchOffice
        fields = ('id', 'name')


class CreateBranchOfficeSerializer(serializers.ModelSerializer):

    class Meta:
        model = BranchOffice
        fields = ('name', 'phone_number', 'address', 'short_description', 'tax_number', 'organization')
        
    def update(self, instance, validated_data):
        validated_data.pop('organization')
        return super().update(instance,validated_data)
