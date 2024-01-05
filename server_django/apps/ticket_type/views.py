from django.utils.decorators import method_decorator
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework.parsers import JSONParser
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
import datetime

from apps.common.constants import TicketType, ByTime

import apps.common.response_interface as rsp
from apps.common.view_helper import GenericViewSet
from apps.ticket_type.serializers import *
from apps.common.custom_permisstion import *


@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
class TicketReasonView(GenericViewSet):
    # permission_classes = [IsAuthenticated]

    serializer_class = TicketReasonSerializer
    action_serializers = {
        'create_request': CreateTicketReasonSerializer,
        'partial_update_request': UpdateTicketReasonSerializer,
    }
    queryset = TicketReason.objects.filter(deleted_at__isnull=True)
    parser_classes = [JSONParser]
    

    permission_action_classes = {
        'create': [IsSuperUser | IsAdminUser | IsCeoUser],
        'list': [IsAuthenticated],
        'retrieve': [PermissionTicketReason],
        'partial_update': [IsSuperUser | IsAdminUser | IsCeoUser],
        'destroy': [IsSuperUser | IsAdminUser | IsCeoUser]
    }

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter('organization_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('by_time', openapi.IN_QUERY, type=openapi.TYPE_INTEGER,
                          enum=[key.value for key in ByTime]),
        openapi.Parameter('ticket_type', openapi.IN_QUERY, type=openapi.TYPE_INTEGER, enum=[key.value for key in TicketType]),
    ])
    def list(self, request, *args, **kwargs):
        user_type = request.user.user_type
        if user_type == UserType.ADMIN.value:
            queryset = self.queryset
        else:
            org = UserWork.objects.filter(user=request.user, deleted_at__isnull=True).first().organization
            queryset = self.queryset.filter(organization=org)

        organization_id = request.query_params.get('organization_id', None)
        if organization_id:
            queryset = queryset.filter(organization_id=organization_id)

        ticket_type = request.query_params.get('ticket_type', None)
        if ticket_type:
            queryset = queryset.filter(ticket_type=ticket_type)

        by_time = request.query_params.get('by_time', None)
        if by_time:
            queryset = queryset.filter(by_time=by_time)

        serializer = self.serializer_class(queryset, many=True)
        general_response = rsp.Response(serializer.data).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)

    def create(self, request, *args, **kwargs):
        serializer = self.get_request_serializer(data=request.data)
        is_valid = serializer.is_valid(raise_exception=True)
        if is_valid:
            instance = self.perform_create(serializer)
            serializer = self.serializer_class(instance)
            general_response = rsp.Response(serializer.data).generate_response()
            return Response(general_response, status=status.HTTP_201_CREATED)

    def partial_update(self, request, *args, **kwargs):
        return super().partial_update(request, custom_data=request.data, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        o = self.get_object()
        o.deleted_at = datetime.now()
        o.save()
        general_response = rsp.Response(self.serializer_class(o).data).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)
