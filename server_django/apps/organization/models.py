from django.db import models

from apps.common.models import CommonModel
from apps.common.models import TrimmedCharFieldModel


class Organization(CommonModel):
    name = TrimmedCharFieldModel(max_length=255, blank=False, null=False)
    logo = models.ImageField(upload_to='logos', default='logos/logo_default_company.jpg')
    phone_number = TrimmedCharFieldModel(max_length=11, blank=True, null=True)
    email = models.EmailField(max_length=255, blank=True, null=True)
    address = TrimmedCharFieldModel(max_length=255)
    
    class Meta:
        db_table = 'organization'