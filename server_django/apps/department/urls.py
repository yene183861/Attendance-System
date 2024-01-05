from django.conf.urls import url
from django.urls import include
from rest_framework.routers import DefaultRouter
from apps.department.views import DepartmentViewSet

router = DefaultRouter()
router.register('', DepartmentViewSet)

urlpatterns = [
    url('department/', include(router.urls)),
]

