from django.urls import include, re_path
from rest_framework.routers import DefaultRouter

from apps.authentication.views import AuthenticationView, LogoutViewSet, ResetPasswordViewSet

router_auth = DefaultRouter()
router_auth.register(r'reset-password', ResetPasswordViewSet)
router_auth.register(r'logout', LogoutViewSet)


auth_urlpatterns = [
    re_path(r'login/$', AuthenticationView.AuthenticationViewSet.as_view()),
]
auth_urlpatterns += router_auth.urls