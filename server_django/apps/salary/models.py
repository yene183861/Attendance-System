from django.db import models
from apps.authentication.models import User
from apps.common.models import CommonModel, TrimmedCharFieldModel


class Payroll(CommonModel):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='salary')
    month = models.DateField()
    real_field = models.FloatField(default=0.0)
    total_salary = models.FloatField(default=0.0)
    total_allowance = models.FloatField(default=0.0)
    total_bonus = models.FloatField(default=0.0)
    total_punish = models.FloatField(default=0.0)
    # tiền phạt đến muộn
    penalty_being_late = models.FloatField(default=0.0, blank=False, null=False)
    # # tiền phạt về sớm
    early_return_penalty = models.FloatField(default=0.0, blank=False, null=False)
    # # tiền phạt nghỉ không lý do
    penalty_leaving_without_reason = models.FloatField(default=0.0, blank=False, null=False)
    # # tiền phạt quên chấm công
    penalty_forgetting_attendance = models.FloatField(default=0.0, blank=False, null=False)

    insurance = models.FloatField(default=0.0)
    tax = models.FloatField(default=0.0)
    is_closed = models.BooleanField(default=False)

    class Meta:
        db_table = 'payroll'
        # abstract = True
