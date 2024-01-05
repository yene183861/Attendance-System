from django.conf.urls import url
from django.urls import include
from rest_framework.routers import DefaultRouter
from apps.attendance.views import *

router = DefaultRouter()
# router.register('work-type', WorkTypeViewSet)
router.register('attendance', AttendanceViewSet)
router.register('attendance/face/create', FaceAttendanceViewSet, basename='attendance')
# router.register('attendance/face', FaceAttendanceView, basename='attendance')

urlpatterns = [
    url('', include(router.urls)),
]

