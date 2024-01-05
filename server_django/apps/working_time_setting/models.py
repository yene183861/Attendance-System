from django.db import models
from apps.user.models import User
from apps.organization.models import Organization
from apps.common.models import TrimmedCharFieldModel, CommonModel


class WorkingTimeType(CommonModel):
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE, related_name='working_time_setting_type')
    start_time = models.TimeField()
    end_time = models.TimeField()
    break_time = models.TimeField()
    status = models.BooleanField(default=True)
    default = models.BooleanField(default=False)

    class Meta:
        db_table = 'working_time_setting_type'

class WorkingTimeSetting(CommonModel):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='working_time')
    start_date = models.DateField()
    end_date = models.DateField()
    setting_type = models.ForeignKey(WorkingTimeType, on_delete=models.CASCADE, related_name='working_time')
    status = models.BooleanField(default=True)

    class Meta:
        db_table = 'working_time_setting'



