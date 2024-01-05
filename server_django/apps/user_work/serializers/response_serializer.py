from rest_framework import serializers


from apps.department.serializers import DepartmentSerializer, DepartmentCommonSerializer
from apps.branch_office.serializers import BranchOfficeSerializer, BranchOfficeCommonSerializer
from apps.team.serializers import TeamSerializer, TeamCommonSerializer
from apps.organization.serializers import OrganizationSerializer, OrganizationCommonSerializer
from apps.user.serializers import  UserSerializer

from apps.user_work.models import UserWork

    
class UserWorkSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    department = DepartmentSerializer()
    branch_office = BranchOfficeSerializer()
    organization = OrganizationSerializer()
    team = TeamSerializer()

    class Meta:
        model = UserWork
        fields = ( 'id', 'user', 'user_type', 'organization', 'branch_office', 'department', 'team', 'position', 'work_status','reason')





    
