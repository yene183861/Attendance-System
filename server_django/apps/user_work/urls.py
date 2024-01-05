from django.conf.urls import url
from django.urls import include
from rest_framework.routers import DefaultRouter
from apps.user_work.views import StaffTranformViewSet

router = DefaultRouter()
router.register('', StaffTranformViewSet)

urlpatterns = [
    url('user-work/', include(router.urls)),
]

