from django.conf.urls import url
from django.urls import include
from rest_framework.routers import DefaultRouter
from apps.salary.views import PayrollViewSet

router = DefaultRouter()
router.register('', PayrollViewSet)

urlpatterns = [
    url('payroll/', include(router.urls)),
]

