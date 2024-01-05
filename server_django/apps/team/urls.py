from django.conf.urls import url
from django.urls import include
from rest_framework.routers import DefaultRouter
from apps.team.views import TeamViewSet

router = DefaultRouter()
router.register('', TeamViewSet)

urlpatterns = [
    url('team/', include(router.urls)),
]

