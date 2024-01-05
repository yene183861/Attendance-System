import datetime

from django.utils.decorators import method_decorator
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status

import apps.common.response_interface as rsp
from apps.common.constants import UserType
from apps.common.error_code import ErrorCode
from apps.common.exception import CustomException
from apps.common.utils import queryset_by_user_permission_to_object
from apps.common.view_helper import GenericViewSet, EmptySerializer
from apps.common.custom_permisstion import IsSuperUser, IsAdminUser, HasPermissionTeam, IsCeoUser, IsDirectorUser, \
    IsManagerUser

from apps.team.serializers import TeamSerializer, CreateTeamSerializer
from apps.team.models import Team
from apps.user.models import User
from apps.user.serializers import UserSerializer
from apps.user_work.models import UserWork
from apps.user_work.serializers.response_serializer import UserWorkSerializer


@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='create', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='partial_update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='destroy', decorator=swagger_auto_schema(auto_schema=None))
class EmailSearchViewSet(GenericViewSet):
    permission_classes = [IsAuthenticated]
    serializer_class = UserSerializer
    action_serializers = {
    }
    queryset = User.object.filter(deleted_at__isnull=True)
    parser_classes = [JSONParser]

    # permission_action_classes = {
    #     'create': [IsSuperUser, IsAdminUser, (IsCeoUser or IsDirectorUser or IsManagerUser) and HasPermissionTeam],
    #     'list': [HasPermissionTeam],
    #     'retrieve': [HasPermissionTeam],
    #     'update': [IsSuperUser, IsAdminUser, (IsCeoUser or IsDirectorUser or IsManagerUser) and HasPermissionTeam],
    #     'destroy': [IsSuperUser, IsAdminUser,  (IsCeoUser or IsDirectorUser or IsManagerUser) and HasPermissionTeam]
    # }

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter('email', openapi.IN_QUERY, type=openapi.TYPE_STRING, required=False),
        openapi.Parameter('name', openapi.IN_QUERY, type=openapi.TYPE_STRING, required=False),
    ])
    def list(self, request, *args, **kwargs):
            print('go heeee')
            email = request.query_params.get('email', None)
            name = request.query_params.get('name', None)

            user_type = request.user.user_type
            if user_type == UserType.ADMIN.value:
                queryset = self.queryset
            else:
                user_work_queryset = queryset_by_user_permission_to_object(request.user, UserWork.objects.filter(
                    deleted_at__isnull=True))
                users_id = [user_work.user.id for user_work in user_work_queryset]

                queryset = self.queryset.filter(pk__in=users_id)
            print('go heeee 1')
            print(queryset)
            if email:
                queryset = queryset.filter(email__icontains=email)
                print(queryset)
            if name:
                queryset = queryset.filter(full_name__icontains=name).exclude(id=request.user.id)

                print(queryset)
            if queryset.count() > 0:
                print(queryset)
                users = [i for i in queryset]

                queryset = UserWork.objects.filter(user__in=users)

                # print(queryset)
                serializer = UserWorkSerializer(queryset, many=True)
                print('go heeee 2')
                general_response = rsp.Response(serializer.data).generate_response()
                print(general_response)
                return Response(general_response, status=status.HTTP_200_OK)
            else:
                print('go heeee 3')
                general_response = rsp.Response(None).generate_response()
                return Response(general_response, status=status.HTTP_200_OK)
