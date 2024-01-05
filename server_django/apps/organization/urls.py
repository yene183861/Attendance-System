from django.conf.urls import url
from django.urls import include
from rest_framework.routers import DefaultRouter
from apps.organization.views import OrganizationView, CreateOrganizationView

router = DefaultRouter()
router.register('organization', OrganizationView)
router.register('organization/create', CreateOrganizationView, basename='organization')

urlpatterns = [
    url('', include(router.urls)),
]
