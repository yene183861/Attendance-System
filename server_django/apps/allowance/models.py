from django.db import models

from apps.organization.models import Organization
from apps.common.models import CommonModel, TrimmedCharFieldModel
from apps.common.constants import ByTime


class Allowance(CommonModel):
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE, related_name='allowance')
    name = TrimmedCharFieldModel(max_length=255, null=False, blank=False)
    description = TrimmedCharFieldModel(max_length=255, blank=True, null=True)
    amount = models.FloatField(default=0.0, null=False, blank=False)
    maximum_amount = models.FloatField(default=0.0)
    by_time = models.IntegerField(choices=ByTime.choices())

    class Meta:
        db_table = 'allowance'
