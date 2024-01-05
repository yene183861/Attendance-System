from apps.authentication.router import auth_urlpatterns

from django.urls import path, include

urlpatterns = [
    path('auth/', include(auth_urlpatterns))
]