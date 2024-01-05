from django.conf.urls import url
from django.urls import include
from rest_framework.routers import DefaultRouter
from apps.branch_office.views import BranchOfficeView

router = DefaultRouter()
router.register('', BranchOfficeView)

urlpatterns = [
    url('branch-office/', include(router.urls)),
]

