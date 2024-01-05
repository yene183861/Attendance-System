from django.db import models

from apps.user.models import User
from apps.organization.models import Organization
from apps.branch_office.models import BranchOffice
from apps.department.models import Department
from apps.team.models import Team

from apps.common.constants import *
from apps.common.models import CommonModel, TrimmedCharFieldModel


class UserWork(CommonModel):
    user = models.OneToOneField(User, on_delete=models.CASCADE, null=True)
    team = models.ForeignKey(Team, on_delete=models.SET_NULL, blank=True, null=True)
    department = models.ForeignKey(Department, on_delete=models.SET_NULL, blank=True, null=True)
    branch_office = models.ForeignKey(BranchOffice, on_delete=models.SET_NULL, blank=True, null=True)
    organization = models.ForeignKey(Organization, on_delete=models.SET_NULL, blank=True, null=True)
    user_type = models.IntegerField(choices=UserType.choices(), default=UserType.STAFF.value)
    # vị trí (Software Engineer,...)
    position = TrimmedCharFieldModel(max_length=255, default='', blank=True, null=True)
    # trạng thái ( tạm hoãn làm việc, đang làm việc...)
    work_status = models.IntegerField(choices=WorkStatus.choices(), default=WorkStatus.WORKING.value)
    # lý do nghỉ, lý do hoãn làm (đi nghĩa vụ, nghỉ đẻ...)
    reason = TrimmedCharFieldModel(max_length=255, default='', blank=True, null=True)

    class Meta:
        db_table = 'user_work'
        unique_together = ['user', 'organization']





