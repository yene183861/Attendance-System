from django.contrib import admin
from apps.attendance.models import Attendance, FaceAttendance

# Register your models here.

admin.site.register(Attendance)
admin.site.register(FaceAttendance)
