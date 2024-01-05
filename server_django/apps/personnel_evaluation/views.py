import datetime

from django.utils.decorators import method_decorator
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework.parsers import JSONParser
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from django.conf import settings

import apps.common.response_interface as rsp
from apps.common.constants import UserType
from apps.common.error_code import ErrorCode
from apps.common.exception import CustomException
from apps.common.utils import queryset_by_user_permission_to_object, filter_by_common_parameter, get_last_date_of_month
from apps.common.view_helper import GenericViewSet

from apps.personnel_evaluation.serializers import PersonnelEvaluationSerializer, CreatePersonnelEvaluationSerializer, \
    UpdatePersonnelEvaluationSerializer
from apps.personnel_evaluation.models import PersonnelEvaluation


# @method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
# class PersonnelEvaluationViewSet(GenericViewSet):
#     permission_classes = [IsAuthenticated]
#     serializer_class = PersonnelEvaluationSerializer
#     queryset = PersonnelEvaluation.objects.filter(deleted_at__isnull=True).order_by('id')
#     parser_classes = [JSONParser]
#     action_serializers = {
#         'create_request': CreatePersonnelEvaluationSerializer,
#         'partial_update_request': UpdatePersonnelEvaluationSerializer,
#     }
#
#     @swagger_auto_schema(manual_parameters=[
#         openapi.Parameter('organization_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
#         openapi.Parameter('branch_office_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
#         openapi.Parameter('department_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
#         openapi.Parameter('team_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
#         openapi.Parameter('status', openapi.IN_QUERY, type=openapi.TYPE_BOOLEAN),
#         openapi.Parameter('month', openapi.IN_QUERY, type=openapi.TYPE_STRING, format=settings.DATE_FORMATS[0]),
#         openapi.Parameter('user_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
#     ])
#     def list(self, request, *args, **kwargs):
#         user_type = request.user.user_type
#         if user_type == UserType.ADMIN.value:
#             queryset = self.queryset
#         else:
#             if user_type == UserType.STAFF.value:
#                 queryset = self.queryset.filter(user=request.user)
#             else:
#                 queryset = queryset_by_user_permission_to_object(request.user, self.queryset)
#
#         organization_id = request.query_params.get('organization_id', None)
#         branch_office_id = request.query_params.get('branch_office_id', None)
#         department_id = request.query_params.get('department_id', None)
#         team_id = request.query_params.get('team_id', None)
#         state = request.query_params.get('status', None)
#         month = request.query_params.get('month', None)
#         user_id = request.query_params.get('user_id', None)
#
#         queryset = filter_by_common_parameter(queryset, organization_id, branch_office_id, department_id, team_id)
#
#         if state:
#             queryset = queryset.filter(status=state)
#         if month:
#             month = get_last_date_of_month(month)
#             queryset = queryset.filter(month=month)
#         if user_id:
#             queryset = queryset.filter(user_id=user_id)
#
#         serializer = self.get_response_serializer(queryset, many=True)
#         general_response = rsp.Response(serializer.data).generate_response()
#         return Response(general_response, status=status.HTTP_200_OK)
#
#     def create(self, request, *args, **kwargs):
#         serializer = self.get_request_serializer(data=request.data, context={'request': request})
#         is_valid = serializer.is_valid(raise_exception=True)
#         if is_valid:
#             instance = self.perform_create(serializer)
#             serializer = self.serializer_class(instance)
#             general_response = rsp.Response(serializer.data).generate_response()
#             return Response(general_response, status=status.HTTP_201_CREATED)
#
#     def partial_update(self, request, *args, **kwargs):
#         return super().partial_update(request, custom_data=request.data, *args, **kwargs)
#
#     def destroy(self, request, *args, **kwargs):
#         o = self.get_object()
#         user = request.user
#         if user == o.user and o.status:
#             raise CustomException(ErrorCode.error_client,
#                                   custom_message='Your personnel evaluation sheet has been locked by your superiors and cannot be deleted')
#         o.deleted_at = datetime.datetime.now()
#         o.save()
#         general_response = rsp.Response(self.serializer_class(o).data).generate_response()
#         return Response(general_response, status=status.HTTP_200_OK)
