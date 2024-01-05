import datetime

from django.utils.decorators import method_decorator
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework.parsers import JSONParser
from rest_framework.response import Response
from rest_framework import status

import apps.common.response_interface as rsp
from apps.common.view_helper import GenericViewSet, EmptySerializer
from apps.common.custom_permisstion import IsSuperUser, IsAdminUser, HasPermissionDepartment, IsCeoUser, IsDirectorUser, \
    IsManagerUser

from apps.department.serializers import DepartmentSerializer, CreateDepartmentSerializer

from apps.department.models import Department


@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
class DepartmentViewSet(GenericViewSet):
    serializer_class = DepartmentSerializer
    action_serializers = {
        'list_response': EmptySerializer,
        'create_request': CreateDepartmentSerializer,
        'partial_update_request': CreateDepartmentSerializer,
    }
    queryset = Department.objects.filter(deleted_at__isnull=True).order_by('-id')
    parser_classes = [JSONParser]

    # permission_action_classes = {
    #     'create': [IsSuperUser, IsAdminUser, (IsCeoUser or IsDirectorUser) and HasPermissionDepartment],
    #     'list': [HasPermissionDepartment],
    #     'retrieve': [HasPermissionDepartment],
    #     'update': [IsSuperUser, IsAdminUser, (IsCeoUser or IsDirectorUser) and HasPermissionDepartment],
    #     'destroy': [IsSuperUser, IsAdminUser,  (IsCeoUser or IsDirectorUser) and HasPermissionDepartment]
    # }

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter('branch_office_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER, required=True)])
    def list(self, request, *args, **kwargs):
        query_params = request.query_params.get('branch_office_id', None)
        queryset = self.queryset.filter(branch_office_id=query_params).all()
        serializer = self.serializer_class(queryset, many=True)
        general_response = rsp.Response(serializer.data).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)
    
    def partial_update(self, request, custom_instance=None, custom_data=None, *args, **kwargs):
        request.data.pop('branch_office')
        return super().partial_update(request,custom_data = request.data,*args, **kwargs )

    # def create(self, request, *args, **kwargs):
    #     serializer = self.get_request_serializer(data=request.data)
    #     print(serializer)
    #     is_valid = serializer.is_valid(raise_exception=True)
    #     if is_valid:
    #         instance = self.perform_create(serializer)
    #         if isinstance(instance, list):
    #             serializer = self.get_response_serializer(instance, many=True)
    #         else:
    #             serializer = self.get_response_serializer(instance)
    #         general_response = rsp.Response(serializer.data).generate_response()
    #         return Response(general_response, status=status.HTTP_201_CREATED)

    def destroy(self, request, *args, **kwargs):
        o = self.get_object()
        o.deleted_at = datetime.datetime.now()
        o.save()
        general_response = rsp.Response(self.serializer_class(o).data).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)
