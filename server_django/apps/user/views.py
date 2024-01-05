from rest_framework.response import Response
from rest_framework import status
from django.utils.decorators import method_decorator
from drf_yasg.utils import swagger_auto_schema
from rest_framework.permissions import IsAuthenticated
from rest_framework.parsers import JSONParser, MultiPartParser

import apps.common.response_interface as rsp
from apps.common.error_code import ErrorCode
from apps.common.exception import CustomException
from apps.common.custom_permisstion import IsStaffUser
from apps.common.constants import UserType
from apps.common.view_helper import GenericViewSet

from apps.user.models import User

from apps.user.serializers import CreateUserSerializer, UserSerializer, UpdateProfileSerializer
from apps.user.serializers import ChangePasswordSerializer
from apps.user_work.serializers.request_serializer import CreateUserWorkSerializer
from apps.user_work.serializers.response_serializer import UserWorkSerializer


@method_decorator(name='list', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='retrieve', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='partial_update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='destroy', decorator=swagger_auto_schema(auto_schema=None))
class UserCreateViewSet(GenericViewSet):
    permission_classes = [~IsStaffUser]
    response_serializer_class = UserSerializer
    request_serializer_class = CreateUserSerializer
    parser_classes = [JSONParser]
    queryset = User.object.all()

    def create(self, request, *args, **kwargs):
        data = request.data
        user_work = data.pop('user_work')
        user_serializer = CreateUserSerializer(data=data)
        is_valid = user_serializer.is_valid(raise_exception=True)
        if is_valid:
            user_type = request.data.get('user_type', None)
            if user_type != UserType.ADMIN.value:
                if not user_work:
                    return CustomException(ErrorCode.error_json_parser,
                                           custom_message='user_work is required').make_response(
                        status_code=status.HTTP_400_BAD_REQUEST)
                else:
                    user_work['user_type'] = user_type
                    user_work_serializer = CreateUserWorkSerializer(data=user_work)
                    is_valid = user_work_serializer.is_valid(raise_exception=True)

                    if is_valid:
                        instance = self.perform_create(user_serializer)
                        print('create user success')
                        user_data = self.response_serializer_class(instance)
                        response_data = {
                            'user': user_data.data
                        }
                        user_work_serializer.validated_data['user'] = instance
                        user_work = self.perform_create(user_work_serializer)
                        user_work_data = UserWorkSerializer(user_work)
                        response_data['work'] = user_work_data.data
                        general_response = rsp.Response(response_data).generate_response()
                        return Response(general_response, status=status.HTTP_201_CREATED)


            else:
                instance = self.perform_create(user_serializer)
                user_data = self.response_serializer_class(instance)
                response_data = {
                    'user': user_data.data
                }
                general_response = rsp.Response(response_data).generate_response()
                return Response(general_response, status=status.HTTP_201_CREATED)


@method_decorator(name='list', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='retrieve', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='partial_update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='destroy', decorator=swagger_auto_schema(auto_schema=None))
class ChangePasswordViewSet(GenericViewSet):
    permission_classes = (IsAuthenticated,)
    serializer_class = ChangePasswordSerializer

    def get_object(self):
        obj = self.request.user
        return obj

    def create(self, request, *args, **kwargs):
        obj = self.get_object()
        serializer = self.get_serializer(data=request.data)
        is_valid = serializer.is_valid(raise_exception=True)
        if is_valid:
            obj.set_password(serializer.data.get('new_password'))
            obj.save()
            general_response = rsp.Response(None).generate_response()
            print(general_response)
            return Response(general_response, status=status.HTTP_200_OK)


@method_decorator(name='list', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='retrieve', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='destroy', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='partial_update', decorator=swagger_auto_schema(auto_schema=None))
class UpdateProfileViewSet(GenericViewSet):
    permission_classes = (IsAuthenticated,)
    response_serializer_class = UserSerializer
    request_serializer_class = UpdateProfileSerializer

    parser_classes = [MultiPartParser]
    queryset = User.object.filter(deleted_at__isnull=True)

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        is_valid = serializer.is_valid(raise_exception=True)
        if is_valid:
            instance = self.perform_create(serializer)
            general_response = UserSerializer(instance)
            general_response = rsp.Response(general_response.data).generate_response()
            return Response(general_response, status=status.HTTP_200_OK)
