from rest_framework.response import Response
from rest_framework import status
from django.utils.decorators import method_decorator
from drf_yasg.utils import swagger_auto_schema
from rest_framework.permissions import IsAuthenticated
from rest_framework.parsers import JSONParser
from django.db.models import Q
from drf_yasg import openapi

import apps.common.response_interface as rsp
from apps.common.utils import queryset_by_user_permission_to_object, filter_by_common_parameter
from apps.common.view_helper import GenericViewSet

from apps.common.constants import UserType

from apps.user.models import User
from apps.common.custom_permisstion import IsSuperUser, IsAdminUser

from apps.user.serializers import CreateUserSerializer, UserSerializer
from apps.user.serializers import ChangePasswordSerializer
from apps.user_work.serializers.request_serializer import UpdateUserWorkSerializer
from apps.user_work.serializers.response_serializer import UserWorkSerializer
from apps.user_work.models import UserWork


# @method_decorator(name='list', decorator=swagger_auto_schema(auto_schema=None))
# @method_decorator(name='retrieve', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='create', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='destroy', decorator=swagger_auto_schema(auto_schema=None))
class StaffTranformViewSet(GenericViewSet):
    permission_classes = [IsAuthenticated]
    response_serializer_class = UserWorkSerializer
    request_serializer_class = UpdateUserWorkSerializer
    queryset = UserWork.objects.filter(deleted_at__isnull=True)
    parser_classes = [JSONParser]

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
            queryset = queryset_by_user_permission_to_object(request.user, self.queryset)
        print(queryset)
        organization_id = request.query_params.get('organization_id', None)
        branch_office_id = request.query_params.get('branch_office_id', None)
        department_id = request.query_params.get('department_id', None)
        team_id = request.query_params.get('team_id', None)
        user_id = request.query_params.get('user_id', None)

        queryset = filter_by_common_parameter(queryset, organization_id, branch_office_id, department_id, team_id)
        # queryset = queryset.exclude(user=request.user)
        print(queryset)
        if user_id:
            queryset = queryset.filter(user_id=user_id)

            print(queryset)

        serializer = self.get_response_serializer(queryset, many=True)
        general_response = rsp.Response(serializer.data).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)

    def partial_update(self, request, custom_instance=None, custom_data=None, *args, **kwargs):
        return super().partial_update(request, custom_data=request.data)
        # data = request.data
        # instance = self.get_object()
        # work_serializer = UpdateUserWorkSerializer(data=data,
        #                                            context={'instance': instance, 'user_request': request.user})
        # is_valid = work_serializer.is_valid(raise_exception=True)
        # if is_valid:
        #     user_work = self.perform_update(work_serializer)
        #     print('\n')
        #     print(user_work)
        #     user_work_data = self.response_serializer_class(user_work)
        #     general_response = rsp.Response(user_work_data.data).generate_response()
        #     return Response(general_response, status=status.HTTP_200_OK)
