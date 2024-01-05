from django.conf.urls import url
from django.urls import include
from rest_framework.routers import DefaultRouter
from apps.allowance.views import AllowanceViewSet

router = DefaultRouter()
router.register('', AllowanceViewSet)

urlpatterns = [
    url('allowance/', include(router.urls)),
]

