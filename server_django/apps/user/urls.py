from django.conf.urls import url
from django.urls import include
from rest_framework.routers import DefaultRouter
from apps.user.views import UserCreateViewSet, ChangePasswordViewSet, UpdateProfileViewSet

router = DefaultRouter()
router.register('create-user', UserCreateViewSet, basename='create-user')
router.register('change-password', ChangePasswordViewSet, basename='change-password')
router.register('update-profile', UpdateProfileViewSet, basename = 'update-profile')

urlpatterns = [
    url('', include(router.urls)),
]
