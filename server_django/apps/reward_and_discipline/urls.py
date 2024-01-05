from django.conf.urls import url
from django.urls import include
from rest_framework.routers import DefaultRouter
from apps.reward_and_discipline.views import RewardAndDisciplineViewSet

router = DefaultRouter()
router.register('', RewardAndDisciplineViewSet)

urlpatterns = [
    url('reward-and-discipline/', include(router.urls)),
]

