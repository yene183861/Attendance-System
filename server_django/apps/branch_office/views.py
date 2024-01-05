from django.utils.decorators import method_decorator
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework.parsers import JSONParser
from rest_framework.response import Response
from rest_framework import status

import apps.common.response_interface as rsp
from apps.common.view_helper import GenericViewSet, EmptySerializer
from apps.branch_office.serializers import BranchOfficeSerializer, CreateBranchOfficeSerializer
from apps.branch_office.models import BranchOffice
from apps.common.custom_permisstion import IsSuperUser, IsAdminUser, HasPermissionBranchOffice, IsCeoUser, \
    IsDirectorUser


@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
class BranchOfficeView(GenericViewSet):
    serializer_class = BranchOfficeSerializer
    action_serializers = {
        'list_response': EmptySerializer,
        'create_request': CreateBranchOfficeSerializer,
        'partial_update_request': CreateBranchOfficeSerializer,
    }
    queryset = BranchOffice.objects.all()
    parser_classes = [JSONParser]

    permission_action_classes = {
        'create': [IsSuperUser | IsAdminUser | IsCeoUser & HasPermissionBranchOffice],
        'list': [HasPermissionBranchOffice],
        'retrieve': [IsSuperUser | IsAdminUser | (IsCeoUser | IsDirectorUser) & HasPermissionBranchOffice],
        'update': [IsSuperUser | IsAdminUser | (IsCeoUser | IsDirectorUser) & HasPermissionBranchOffice],
        'destroy': [IsSuperUser | IsAdminUser | IsCeoUser & HasPermissionBranchOffice]
    }

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter('organization_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER, required=True)])
    def list(self, request, *args, **kwargs):
        query_params = request.query_params.get('organization_id', None)
        queryset = self.queryset.filter(organization_id=query_params).all()
        serializer = self.serializer_class(queryset, many=True)
        general_response = rsp.Response(serializer.data).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)

    def create(self, request, *args, **kwargs):
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

    def partial_update(self, request, *args, **kwargs):
        return super().partial_update(request, custom_data=request.data, *args, **kwargs)
