from django.db import models
from apps.authentication.models import User
from apps.common.constants import *
from apps.common.models import CommonModel, TrimmedCharFieldModel
from apps.ticket_type.models import TicketReason

from django.core.validators import MaxValueValidator, MinValueValidator, DecimalValidator


class Ticket(CommonModel):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='creator_ticket')
    ticket_type = models.IntegerField(choices=TicketType.choices())
    description = TrimmedCharFieldModel(max_length=255, null=True)
    status = models.IntegerField(
        choices=TicketStatus.choices(), default=TicketStatus.PENDING.value)
    reviewer = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='reviewer')
    reviewer_opinions = TrimmedCharFieldModel(max_length=255, null=True, blank=True)

    class Meta:
        db_table = 'ticket'


class DateTimeTicket(CommonModel):
    ticket = models.ForeignKey(Ticket, on_delete=models.CASCADE, related_name='date_time_tickets')
    start_date_time = models.DateTimeField()
    end_date_time = models.DateTimeField()
    ticket_reason = models.ForeignKey(TicketReason, on_delete=models.CASCADE, blank=True, null=True,
                                      related_name='date_time_ticket')

    class Meta:
        db_table = 'date_time_ticket'
