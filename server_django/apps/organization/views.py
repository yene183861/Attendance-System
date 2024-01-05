from django.utils.decorators import method_decorator
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework.parsers import JSONParser, MultiPartParser
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from django.db.models import Q
from apps.common.custom_permisstion import *
import apps.common.response_interface as rsp
from apps.common.view_helper import GenericViewSet, EmptySerializer
from apps.organization.models import Organization
from apps.organization.serializers import OrganizationSerializer, CreateOrganizationSerializer, \
    OrganizationCommonSerializer
from apps.user.models import User
from apps.common.constants import UserType


@method_decorator(name='create', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='partial_update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
class OrganizationView(GenericViewSet):
    serializer_class = OrganizationSerializer
    action_serializers = {
        'list_response': EmptySerializer,
        'create_request': CreateOrganizationSerializer,
        'partial_update_request': CreateOrganizationSerializer,
    }
    queryset = Organization.objects.all()
    parser_classes = [JSONParser]

    # permission_action_classes = {
    #     'create': [IsSuperUser, IsAdminUser],
    #     'list': [IsSuperUser, IsAdminUser, IsCeoUser and HasPermissionOrganigation],
    #     'retrieve': [IsSuperUser, IsAdminUser, IsCeoUser and HasPermissionOrganigation],
    #     'update': [IsSuperUser, IsAdminUser, IsCeoUser and HasPermissionOrganigation],
    #     'destroy': [IsSuperUser, IsAdminUser]
    # }

    def list(self, request, *args, **kwargs):
        print(request.user.user_type)
        if request.user.user_type == UserType.ADMIN.value:
            queryset = Organization.objects.all()
            serializer = self.serializer_class(queryset, many=True)
        else:
            queryset = Organization.objects.filter(
                Q(userwork__user=request.user, userwork__user_type=UserType.CEO.value))
            serializer = OrganizationCommonSerializer(queryset, many=True)
        general_response = rsp.Response(serializer.data).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)

    def create(self, request, *args, **kwargs):
        serializer = self.get_request_serializer(data=request.data)
        is_valid = serializer.is_valid(raise_exception=True)
        if is_valid:
            organization = self.perform_create(serializer)
            serializer = self.get_response_serializer(organization)
            general_response = rsp.Response(serializer.data).generate_response()
            return Response(general_response, status=status.HTTP_201_CREATED)



@method_decorator(name='list', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='retrieve', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='destroy', decorator=swagger_auto_schema(auto_schema=None))
class CreateOrganizationView(GenericViewSet):
    serializer_class = OrganizationSerializer
    action_serializers = {
        'create_request': CreateOrganizationSerializer,
        'partial_update_request': CreateOrganizationSerializer,
    }
    queryset = Organization.objects.all()
    parser_classes = [MultiPartParser]

    # permission_action_classes = {
    #     'create': [IsSuperUser, IsAdminUser],
    #     'list': [IsSuperUser, IsAdminUser, IsCeoUser and HasPermissionOrganigation],
    #     'retrieve': [IsSuperUser, IsAdminUser, IsCeoUser and HasPermissionOrganigation],
    #     'update': [IsSuperUser, IsAdminUser, IsCeoUser and HasPermissionOrganigation],
    #     'destroy': [IsSuperUser, IsAdminUser]
    # }

    def list(self, request, *args, **kwargs):
        print(request.user.user_type)
        if request.user.user_type == UserType.ADMIN.value:
            queryset = Organization.objects.all()
            serializer = self.serializer_class(queryset, many=True)
        else:
            queryset = Organization.objects.filter(
                Q(userwork__user=request.user, userwork__user_type=UserType.CEO.value))
            serializer = OrganizationCommonSerializer(queryset, many=True)
        general_response = rsp.Response(serializer.data).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)


    def create(self, request, *args, **kwargs):
        serializer = self.get_request_serializer(data=request.data)
        is_valid = serializer.is_valid(raise_exception=True)
        if is_valid:
            organization = self.perform_create(serializer)
            serializer = self.get_response_serializer(organization)
            general_response = rsp.Response(serializer.data).generate_response()
            return Response(general_response, status=status.HTTP_201_CREATED)
