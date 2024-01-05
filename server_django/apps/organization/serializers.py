from rest_framework import serializers

from apps.organization.models import Organization
from apps.user.serializers import UserSerializer
from apps.user_work.models import UserWork
from django.db.models import Q

from apps.common.constants import UserType


class OrganizationSerializer(serializers.ModelSerializer):
    owner = serializers.SerializerMethodField()
    number_employees = serializers.SerializerMethodField()

    class Meta:
        model = Organization
        fields = ('id', 'name', 'logo', 'phone_number', 'email', 'address', 'owner', 'number_employees')

    @staticmethod
    def get_owner(instance):
        owner = UserWork.objects.filter(organization=instance, user_type=UserType.CEO.value, deleted_at__isnull=True).first()
        if not owner:
            return None
        serializer = UserSerializer(owner.user)
        return serializer.data

    def get_number_employees(self, instance):
        owner = UserWork.objects.filter(organization=instance, deleted_at__isnull=True)
        if not owner:
            return 0
        return owner.count()



class OrganizationCommonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Organization
        fields = ('id', 'name', 'logo', 'phone_number', 'email', 'address')


class CreateOrganizationSerializer(serializers.ModelSerializer):

    class Meta:
        model = Organization
        fields = ('name', 'logo', 'phone_number', 'email', 'address')