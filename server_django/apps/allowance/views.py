from django.utils.decorators import method_decorator
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework.parsers import JSONParser
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated

import apps.common.response_interface as rsp
from apps.common.error_code import ErrorCode
from apps.common.exception import CustomException
from apps.common.view_helper import GenericViewSet, EmptySerializer
from apps.allowance.serializers import AllowanceSerializer, CreateAllowanceSerializer
from apps.allowance.models import Allowance
from apps.common.custom_permisstion import *
import datetime


@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
class AllowanceViewSet(GenericViewSet):
    serializer_class = AllowanceSerializer
    action_serializers = {
        'list_response': EmptySerializer,
        'create_request': CreateAllowanceSerializer,
        'partial_update_request': CreateAllowanceSerializer,
    }
    queryset = Allowance.objects.filter(deleted_at__isnull=True)
    parser_classes = [JSONParser]

    permission_action_classes = {
        'create': [IsSuperUser|IsAdminUser|IsCeoUser],
        'list': [],
        'retrieve': [],
        'update': [IsSuperUser|IsAdminUser|IsCeoUser],
        'destroy': [IsSuperUser|IsAdminUser|IsCeoUser]
    }

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter('organization_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER)])
    def list(self, request, *args, **kwargs):
        user_type = request.user.user_type
        if user_type == UserType.ADMIN.value:
            queryset = self.queryset
        else:
            organization = UserWork.objects.filter(user=request.user, deleted_at__isnull=True).first().organization
            queryset = self.queryset.filter(organization=organization)

        query_params = request.query_params.get('organization_id', None)
        if query_params:
            queryset = queryset.filter(organization_id=query_params)

        serializer = self.serializer_class(queryset, many=True)
        general_response = rsp.Response(serializer.data).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)

    def create(self, request, *args, **kwargs):
        organization = request.data.get('organization')
        user_type = request.user.user_type
        if user_type != UserType.ADMIN.value:
            org = UserWork.objects.filter(user=request.user, deleted_at__isnull=True).first().organization
            print('\n')
            print(org)
            print(organization)
            print('\n')
            if org != organization:
                raise CustomException(ErrorCode.error_not_permisstion)
        serializer = self.get_request_serializer(data=request.data)
        is_valid = serializer.is_valid(raise_exception=True)
        if is_valid:
            instance = self.perform_create(serializer)
            if isinstance(instance, list):
                serializer = self.get_response_serializer(instance, many=True)
            else:
                serializer = self.get_response_serializer(instance)
            general_response = rsp.Response(serializer.data).generate_response()
            return Response(general_response, status=status.HTTP_201_CREATED)

    def destroy(self, request, *args, **kwargs):
        o = self.get_object()
        o.deleted_at = datetime.datetime.now()
        o.save()
        general_response = rsp.Response(self.serializer_class(o).data).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)
