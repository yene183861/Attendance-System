from django.db import models
from apps.authentication.models import User
from apps.branch_office.models import BranchOffice
from apps.common.models import CommonModel
from apps.common.models import TrimmedCharFieldModel


class Department(CommonModel):
    branch_office = models.ForeignKey(BranchOffice, on_delete=models.CASCADE, related_name='department')
    name = TrimmedCharFieldModel(max_length=255, blank=False, null=False)

    class Meta:
        db_table = 'department'
