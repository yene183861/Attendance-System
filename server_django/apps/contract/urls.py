from django.conf.urls import url
from django.urls import include
from rest_framework.routers import DefaultRouter
from apps.contract.views import ContractViewSet

router = DefaultRouter()
router.register('contract', ContractViewSet)

urlpatterns = [
    url('', include(router.urls)),
]

