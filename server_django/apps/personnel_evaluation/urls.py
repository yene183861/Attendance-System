from django.conf.urls import url
from django.urls import include
from rest_framework.routers import DefaultRouter
# from apps.personnel_evaluation.views import PersonnelEvaluationViewSet

router = DefaultRouter()
# router.register('', PersonnelEvaluationViewSet)

urlpatterns = [
    url('personnel-evaluation/', include(router.urls)),
]

