from django.conf.urls import url
from django.urls import include
from rest_framework.routers import DefaultRouter
from apps.team.views import TeamViewSet
from apps.search.views import EmailSearchViewSet

router = DefaultRouter()
router.register('staff', EmailSearchViewSet)

urlpatterns = [
    url('search/', include(router.urls)),
]

