from datetime import datetime
from rest_framework.response import Response
from rest_framework import status
from rest_framework.exceptions import AuthenticationFailed
from django.utils.decorators import method_decorator
from rest_framework_jwt.views import JSONWebTokenAPIView
from drf_yasg.utils import swagger_auto_schema
from rest_framework.permissions import IsAuthenticated

import apps.common.response_interface as rsp
from apps.user.models import User
from apps.authentication.models import Token
from apps.authentication.custom_auth import JWTToken
from apps.common.view_helper import GenericViewSet, EmptySerializer
from apps.authentication.custom_auth import CustomAuthentication
from apps.authentication.serializers import LoginSerializer, ResetPasswordSerializer


class AuthenticationView:
    class AuthenticationViewSet(JSONWebTokenAPIView):
        serializer_class = LoginSerializer
        queryset = User.object.all()

        def post(self, request, *args, **kwargs):
            serializer = LoginSerializer(data=request.data)
            if serializer.is_valid(raise_exception=True):
                user = serializer.validated_data
                try:
                    token = Token.objects.get(user=user)
                    if CustomAuthentication.is_expired(token):
                        time_token = int(datetime.timestamp(datetime.utcnow()))
                        token.token = time_token
                        token.save()
                except Token.DoesNotExist:
                    time_token = int(datetime.timestamp(datetime.utcnow()))
                    token = Token.objects.create(user=user, token=time_token)
                time_token = token.token
                token = JWTToken(user, time_token).make_token(request, status=status.HTTP_200_OK)
                return token
            else:
                raise AuthenticationFailed


@method_decorator(name='list', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='retrieve', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='partial_update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='destroy', decorator=swagger_auto_schema(auto_schema=None))
class LogoutViewSet(GenericViewSet):
    serializer_class = EmptySerializer
    queryset = User.object.all()
    permission_classes = [IsAuthenticated, ]

    def create(self, request, *args, **kwargs):
        Token.objects.filter(user=request.user, token=request.auth.token).delete()
        general_response = rsp.Response(None).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)


@method_decorator(name='list', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='retrieve', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='partial_update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='destroy', decorator=swagger_auto_schema(auto_schema=None))
class ResetPasswordViewSet(GenericViewSet):
    serializer_class = ResetPasswordSerializer
    queryset = User.object.filter(deleted_at__isnull=True)

    def create(self, request, *args, **kwargs):
        data = request.data
        serializer = self.get_serializer(data=data)
        is_valid = serializer.is_valid(raise_exception=True)
        if is_valid:
            serializer.save()
            print('DONEEEEEEE')
            general_response = rsp.Response(None,
                                            custom_message='Mật khẩu mới đã được gửi tới email của bạn. '
                                                           'Vui lòng kiếm tra hòm thư và đăng nhập lại').generate_response()
            return Response(general_response, status=status.HTTP_200_OK)
