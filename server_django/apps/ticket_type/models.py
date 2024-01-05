from django.db import models
from apps.organization.models import Organization
from apps.common.constants import *
from apps.common.models import CommonModel, TrimmedCharFieldModel


class TicketReason(CommonModel):
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE)
    ticket_type = models.IntegerField(choices=TicketType.choices())
    name = TrimmedCharFieldModel(max_length=255)
    is_work_calculation = models.BooleanField()
    description = TrimmedCharFieldModel(max_length=255, null=True, blank=True)
    maximum = models.IntegerField()
    by_time = models.IntegerField(choices=ByTime.choices())

    class Meta:
        db_table = 'ticket_reason'
