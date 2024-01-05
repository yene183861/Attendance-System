from django.db import models
from apps.department.models import Department
from apps.common.models import CommonModel, TrimmedCharFieldModel


class Team(CommonModel):
    department = models.ForeignKey(Department, on_delete=models.CASCADE, related_name='team')
    name = TrimmedCharFieldModel(max_length=255, blank=False, null=False)

    class Meta:
        db_table = 'team'