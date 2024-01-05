import datetime

from django.utils.decorators import method_decorator
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework.parsers import JSONParser
from rest_framework.response import Response
from rest_framework import status

import apps.common.response_interface as rsp
from apps.common.view_helper import GenericViewSet, EmptySerializer
from apps.common.custom_permisstion import IsSuperUser, IsAdminUser, HasPermissionTeam, IsCeoUser, IsDirectorUser, \
    IsManagerUser

from apps.team.serializers import TeamSerializer, CreateTeamSerializer
from apps.team.models import Team


@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
class TeamViewSet(GenericViewSet):
    serializer_class = TeamSerializer
    action_serializers = {
        'list_response': EmptySerializer,
        'create_request': CreateTeamSerializer,
        'partial_update_request': CreateTeamSerializer,
    }
    queryset = Team.objects.filter(deleted_at__isnull=True)
    parser_classes = [JSONParser]

    # permission_action_classes = {
    #     'create': [IsSuperUser, IsAdminUser, (IsCeoUser or IsDirectorUser or IsManagerUser) and HasPermissionTeam],
    #     'list': [HasPermissionTeam],
    #     'retrieve': [HasPermissionTeam],
    #     'update': [IsSuperUser, IsAdminUser, (IsCeoUser or IsDirectorUser or IsManagerUser) and HasPermissionTeam],
    #     'destroy': [IsSuperUser, IsAdminUser,  (IsCeoUser or IsDirectorUser or IsManagerUser) and HasPermissionTeam]
    # }

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter('department_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER, required=True)])
    def list(self, request, *args, **kwargs):
        query_params = request.query_params.get('department_id', None)
        queryset = self.queryset.filter(department_id=query_params)
        serializer = self.serializer_class(queryset, many=True)
        general_response = rsp.Response(serializer.data).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)

    # def create(self, request, *args, **kwargs):
    #     serializer = self.get_request_serializer(data=request.data)
    #     is_valid = serializer.is_valid(raise_exception=True)
    #     if is_valid:
    #         instance = self.perform_create(serializer)
    #         if isinstance(instance, list):
    #             serializer = self.get_response_serializer(instance, many=True)
    #         else:
    #             serializer = self.get_response_serializer(instance)
    #         general_response = rsp.Response(serializer.data).generate_response()
    #         return Response(general_response, status=status.HTTP_201_CREATED)

    # def partial_update(self, request, *args, **kwargs):
    #     return super().partial_update(request, custom_data = request.data, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        o = self.get_object()
        o.deleted_at = datetime.datetime.now()
        o.save()
        general_response = rsp.Response(self.serializer_class(o).data).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)