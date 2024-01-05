from django.utils.decorators import method_decorator
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.parsers import FormParser, FileUploadParser, MultiPartParser, JSONParser

import apps.common.response_interface as rsp
from apps.common.constants import UserType
from apps.common.custom_permisstion import  IsStaffUser, PermissionRegisterFace
from apps.common.utils import queryset_by_user_permission_to_object, filter_by_common_parameter, \
    filter_by_common_parameter_not_field_in_object
from apps.common.view_helper import GenericViewSet, EmptySerializer
from apps.ticket.models import Ticket
from apps.register_face.serializers import CreateRegisterFaceSerializer, RegisterFaceSerializer
from apps.register_face.models import RegisterFace


@method_decorator(name='list', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='retrieve', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='partial_update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='destroy', decorator=swagger_auto_schema(auto_schema=None))
class RegisterFaceViewSet(GenericViewSet):
    permission_classes = [~IsStaffUser]
    request_serializer_class = CreateRegisterFaceSerializer
    response_serializer_class = RegisterFaceSerializer
    queryset = RegisterFace.objects.filter(deleted_at__isnull=True)
    parser_classes = [MultiPartParser]
    def create(self, request, *args, **kwargs):
        serializer = self.get_request_serializer(data=request.data, context={'request': request})
        is_valid = serializer.is_valid(raise_exception=True)
        if is_valid:
            instance = self.perform_create(serializer)
            # print(instance)
            # serializer = RegisterFaceSerializer(instance)
            general_response = rsp.Response(None).generate_response()
            return Response(general_response, status=status.HTTP_201_CREATED)

@method_decorator(name='create', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
class RegisterFaceView(GenericViewSet):
    permission_classes = [IsAuthenticated]
    serializer_class = RegisterFaceSerializer
    queryset = RegisterFace.objects.filter(deleted_at__isnull=True)
    parser_classes = [JSONParser]

    action_serializers = {
        'partial_update_request': CreateRegisterFaceSerializer,
    }

    permission_action_classes = {
        'list': [IsAuthenticated],
        'retrieve': [PermissionRegisterFace],
        'partial_update': [~IsStaffUser & PermissionRegisterFace],
        'destroy': [~IsStaffUser & PermissionRegisterFace]
    }

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter('organization_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('branch_office_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('department_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('team_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('user_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
    ])
    def list(self, request, *args, **kwargs):
        user_type = request.user.user_type
        if user_type == UserType.ADMIN.value:
            queryset = self.queryset
        else:
            if user_type == UserType.STAFF.value:
                queryset = self.queryset.filter(user=request.user)
            else:
                queryset = queryset_by_user_permission_to_object(request.user, self.queryset)

        organization_id = request.query_params.get('organization_id', None)
        branch_office_id = request.query_params.get('branch_office_id', None)
        department_id = request.query_params.get('department_id', None)
        team_id = request.query_params.get('team_id', None)
        user_id = request.query_params.get('user_id', None)

        queryset = filter_by_common_parameter_not_field_in_object(queryset, organization_id, branch_office_id, department_id, team_id)
        print(queryset)
        if user_id:
            queryset = queryset.filter(user_id=user_id)
        print(queryset)
        serializer = self.get_response_serializer(queryset, many=True)
        general_response = rsp.Response(serializer.data).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)