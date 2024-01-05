from django.conf.urls import url
from django.urls import include
from rest_framework.routers import DefaultRouter
from apps.register_face.views import RegisterFaceViewSet, RegisterFaceView

router = DefaultRouter()
router.register('create', RegisterFaceViewSet)
router.register('', RegisterFaceView)

urlpatterns = [
    url('register-face/', include(router.urls)),
]

