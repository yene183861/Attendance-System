from django.contrib import admin
from apps.working_time_setting.models import WorkingTimeSetting, WorkingTimeType

# Register your models here.
admin.site.register(WorkingTimeSetting)
admin.site.register(WorkingTimeType)
