from django.db import models
from apps.authentication.models import User
from apps.common.models import CommonModel
from apps.organization.models import Organization


class BranchOffice(CommonModel):
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE, related_name='branchs')
    name = models.CharField(max_length=255, blank=False, null=False)
    phone_number = models.CharField(max_length=11, blank=True, null=True)
    address = models.CharField(max_length=255, blank=True, null=True)
    short_description = models.CharField(max_length=255, blank=True, null=True)
    tax_number = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        db_table = 'branch_office'

