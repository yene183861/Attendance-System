from django.db import models
from apps.authentication.models import User
from apps.organization.models import Organization
from apps.common.constants import ContractStatus, TicketStatus
from apps.common.models import CommonModel, TrimmedCharFieldModel
from django.core.validators import MinValueValidator, MaxValueValidator
import sys

from apps.common.constants import ContractType


class Contract(CommonModel):
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE, null=False, blank=False,
                                     related_name='contract')
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='contract')
    creator = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='creator_contract')
    approve = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='approver_contract')
    contract_code = TrimmedCharFieldModel(max_length=255)
    basic_salary = models.FloatField(default=0,
                                     validators=[MinValueValidator(0), MaxValueValidator(sys.float_info.max)])
    salary_coefficient = models.FloatField(default=1.0, validators=[MinValueValidator(0), MaxValueValidator(sys.float_info.max)])
    name = TrimmedCharFieldModel(max_length=255)
    state = models.IntegerField(choices=ContractStatus.choices(), default=ContractStatus.INVALID_CONTRACT.value)
    status = models.IntegerField(choices=TicketStatus.choices(), default=TicketStatus.PENDING.value)
    # ngày có hiệu lực
    start_date = models.DateField()
    # ngày hết hiệu lực
    end_date = models.DateField(null=True)
    sign_date = models.DateField(null=True)
    contract_type = models.IntegerField(choices=ContractType.choices(), default=ContractType.SEASONAL_CONTRACT.value)

    class Meta:
        db_table = 'contract'
