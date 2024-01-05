import datetime

from django.utils.decorators import method_decorator
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework.parsers import MultiPartParser, JSONParser
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated

import apps.common.response_interface as rsp
from apps.common.utils import queryset_by_user_permission_to_object, filter_by_common_parameter
from apps.common.view_helper import GenericViewSet, EmptySerializer
from apps.allowance.serializers import AllowanceSerializer, CreateAllowanceSerializer
from apps.allowance.models import Allowance
from apps.common.custom_permisstion import *
from apps.common.constants import UserType
from apps.contract.models import Contract
from apps.contract.serializers import *
from django.db.models import Q

from apps.ticket.models import Ticket


@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
class ContractViewSet(GenericViewSet):
    serializer_class = ContractSerializer
    action_serializers = {
        'create_request': CreateContractSerializer,
        'partial_update_request': UpdateContractSerializer,
    }
    queryset = Contract.objects.filter(deleted_at__isnull=True).order_by('-id')
    parser_classes = [JSONParser]

    permission_action_classes = {
        'create': [IsSuperUser | IsAdminUser | IsCeoUser | IsDirectorUser],
        'list': [IsAuthenticated],
        'retrieve': [PermissionContract],
        'partial_update': [(IsSuperUser | IsAdminUser | IsCeoUser | IsDirectorUser) & PermissionContract],
        'destroy': [(IsSuperUser | IsAdminUser | IsCeoUser | IsDirectorUser) & PermissionContract]
    }

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter('organization_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('branch_office_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('department_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('team_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('state', openapi.IN_QUERY, type=openapi.TYPE_INTEGER,
                          enum=[key.value for key in ContractStatus]),
        openapi.Parameter('status', openapi.IN_QUERY, type=openapi.TYPE_INTEGER,
                          enum=[key.value for key in TicketStatus]),
        openapi.Parameter('start_date', openapi.IN_QUERY, type=openapi.TYPE_STRING, format=settings.DATE_FORMATS[0]),
        openapi.Parameter('contract_type', openapi.IN_QUERY, type=openapi.TYPE_INTEGER,
                          enum=[key.value for key in ContractType]),
        openapi.Parameter('end_date', openapi.IN_QUERY, type=openapi.TYPE_STRING, format=settings.DATE_FORMATS[0]),
        openapi.Parameter('contract_code', openapi.IN_QUERY, type=openapi.TYPE_STRING),
        openapi.Parameter('user_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('creator_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
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
        state = request.query_params.get('state', None)
        contract_type = request.query_params.get('contract_type', None)
        q_status = request.query_params.get('status', None)
        start_date = request.query_params.get('start_date', None)
        end_date = request.query_params.get('end_date', None)
        contract_code = request.query_params.get('contract_code', None)
        user_id = request.query_params.get('user_id', None)
        creator_id = request.query_params.get('creator_id', None)

        queryset = filter_by_common_parameter_not_field_in_object(queryset, organization_id, branch_office_id,
                                                                  department_id, team_id)

        if state:
            queryset = queryset.filter(state=state)
        if contract_type:
            queryset = queryset.filter(contract_type=contract_type)
        if q_status:
            queryset = queryset.filter(status=q_status)
        if start_date:
            queryset = queryset.filter(start_date_gte=start_date)
        if end_date:
            queryset = queryset.filter(end_date__lte=end_date)
        if contract_code:
            queryset = queryset.filter(contract_code__icontains=contract_code)

        if user_id:
            queryset = queryset.filter(user_id=user_id)
        if creator_id:
            queryset = queryset.filter(creator_id=creator_id)

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

    def partial_update(self, request, custom_instance=None, custom_data=None, *args, **kwargs):
        return super().partial_update(request, custom_data=request.data, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        user_request = request.user

        o = self.get_object()
        if user_request.user_type == UserType.DIRECTOR.value:
            if o.status == TicketStatus.APPROVED.value:
                CustomException(ErrorCode.error_not_permisstion, custom_message='Hợp đồng đã được phê duyệt, không thể xóa').make_response(status_code=status.HTTP_400_BAD_REQUEST)
                return
        o.deleted_at = datetime.datetime.now()
        o.save()
        general_response = rsp.Response(self.serializer_class(o).data).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)
