from django.conf.urls import url
from django.urls import include
from rest_framework.routers import DefaultRouter
from apps.working_time_setting.views import WorkingTimeTypeViewSet, WorkingTimeSettingViewSet

router = DefaultRouter()
router.register('working-time-type', WorkingTimeTypeViewSet)
router.register('working-time-setting', WorkingTimeSettingViewSet)

urlpatterns = [
    url('', include(router.urls)),
]

