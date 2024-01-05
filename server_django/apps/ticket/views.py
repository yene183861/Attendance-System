import datetime

from django.utils.decorators import method_decorator
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework.parsers import  JSONParser
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated

from apps.common.constants import TicketType, TicketStatus
from apps.common.custom_permisstion import *

import apps.common.response_interface as rsp
from apps.common.view_helper import GenericViewSet
from apps.ticket.models import Ticket, DateTimeTicket
from apps.ticket.serializers import TicketSerializer, CreateTicketSerializer, UpdateTicketSerializer


@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
class TicketView(GenericViewSet):
    permission_classes = [IsAuthenticated]
    serializer_class = TicketSerializer
    action_serializers = {
        'create_request': CreateTicketSerializer,
        'partial_update_request': UpdateTicketSerializer,
    }
    queryset = Ticket.objects.filter(deleted_at__isnull=True).order_by('-id')
    parser_classes = [JSONParser]
    permission_action_classes = {
        'retrieve': [PermissionTicket],
        'partial_update': [PermissionTicket],
        'destroy': [PermissionTicket]
    }

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter('organization_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('branch_office_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('department_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('team_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('ticket_type', openapi.IN_QUERY, type=openapi.TYPE_INTEGER, enum=[key.value for key in TicketType]),
        openapi.Parameter('ticket_reason_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('status', openapi.IN_QUERY, type=openapi.TYPE_INTEGER,enum=[key.value for key in TicketStatus]),
        openapi.Parameter('user_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('month', openapi.IN_QUERY, type=openapi.TYPE_STRING,format=settings.DATE_FORMATS[0]),
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

        print(queryset)

        organization_id = request.query_params.get('organization_id', None)
        branch_office_id = request.query_params.get('branch_office_id', None)
        department_id = request.query_params.get('department_id', None)
        user_id = request.query_params.get('user_id', None)
        ticket_type = request.query_params.get('ticket_type', None)
        ticket_reason_id = request.query_params.get('ticket_reason_id', None)
        state = request.query_params.get('status', None)
        team_id = request.query_params.get('team_id', None)
        month = request.query_params.get('month', None)

        queryset = filter_by_common_parameter_not_field_in_object(queryset, organization_id, branch_office_id, department_id, team_id)

        if user_id:
            print('\n')
            print('11111')
            print(queryset)
            print(user_id)
            queryset = queryset.filter(user_id=user_id)
            print(queryset)
            print('\n')
        print('\n')
        print(queryset)
        if ticket_type:
            queryset = queryset.filter(ticket_type=ticket_type)
        if ticket_reason_id:
            queryset = queryset.filter(ticket_reason_id=ticket_reason_id)
        if state:
            queryset = queryset.filter(status=state)
        print(queryset)
        if month:
            month = datetime.strptime(month, "%Y-%m-%d").date()
            month = get_last_date_of_month(month)
            first_day = get_first_day_of_month(month)
            print(first_day)
            print(queryset)
            date_time_tickets = DateTimeTicket.objects.filter(
                start_date_time__gte=first_day, start_date_time__lte=month, deleted_at__isnull=True
            )
            print(queryset)
            if date_time_tickets:
                tickets = [i.ticket.id for i in date_time_tickets]
                queryset = queryset.filter(pk__in=tickets)
            else:
                queryset = None
        print(queryset)

        serializer = self.get_response_serializer(queryset, many=True)
        general_response = rsp.Response(serializer.data).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)

    def create(self, request, *args, **kwargs):
        print('\n')
        print('api create ticket')
        serializer = self.get_request_serializer(data=request.data)
        is_valid = serializer.is_valid(raise_exception=True)
        if is_valid:
            instance = self.perform_create(serializer)
            serializer = TicketSerializer(instance)
            general_response = rsp.Response(serializer.data).generate_response()
            return Response(general_response, status=status.HTTP_201_CREATED)

    def partial_update(self, request, *args, **kwargs):

        return super().partial_update(request, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        user = request.user

        o = self.get_object()
        if user == o.user:
            date_tickets = DateTimeTicket.objects.filter(ticket=o, deleted_at__isnull=True)
            if date_tickets:
                for i in date_tickets:
                    i.deleted_at = datetime.now()
                    i.save()
            o.deleted_at = datetime.now()
            o.save()
            general_response = rsp.Response(self.serializer_class(o).data).generate_response()
            return Response(general_response, status=status.HTTP_200_OK)
        else:
            general_response = CustomException(ErrorCode.error_not_permisstion).make_response(status_code=status.HTTP_400_BAD_REQUEST)
            return general_response

