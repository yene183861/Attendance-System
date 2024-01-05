from django.utils.decorators import method_decorator
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework.decorators import action
from rest_framework.parsers import MultiPartParser, JSONParser, FormParser
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from django.conf import settings
import datetime

import apps.common.response_interface as rsp
from apps.common.view_helper import GenericViewSet, EmptySerializer
from apps.common.custom_permisstion import *
from apps.attendance.serializers import *


# view này phục vụ cho việc tạo công thủ công
@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
class AttendanceViewSet(GenericViewSet):
    serializer_class = AttendanceSerializer
    action_serializers = {
        'create_request': CreateAttendanceSerializer,
        'partial_update_request': CreateAttendanceSerializer,
    }
    queryset = Attendance.objects.filter(deleted_at__isnull=True)
    parser_classes = [JSONParser]

    # permission_action_classes = {
    #     'create': [IsSuperUser, IsAdminUser, IsCeoUser and HasPermissionBranchOffice],
    #     'list': [HasPermissionBranchOffice],
    #     'retrieve': [HasPermissionBranchOffice],
    #     'update': [IsSuperUser, IsAdminUser, IsCeoUser and HasPermissionBranchOffice],
    #     'destroy': [IsSuperUser, IsAdminUser,  IsCeoUser and HasPermissionBranchOffice]
    # }

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter('organization_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('branch_office_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('department_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('team_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('user_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('working_day', openapi.IN_QUERY, type=openapi.TYPE_STRING, format=settings.DATE_FORMATS[0]),
        openapi.Parameter('month', openapi.IN_QUERY, type=openapi.TYPE_STRING, format=settings.DATE_FORMATS[0]),
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
        team_id = request.query_params.get('team_id', None)
        working_day = request.query_params.get('working_day', None)
        month = request.query_params.get('month', None)
        user_id = request.query_params.get('user_id', None)

        queryset = filter_by_common_parameter_not_field_in_object(queryset, organization_id, branch_office_id,
                                                                  department_id, team_id)

        if working_day:
            print('\n')
            working_day = datetime.strptime(working_day, "%Y-%m-%d").date()
            print(working_day)
            queryset = queryset.filter(working_day=working_day)
            print(queryset)
            print('\n')
        if month:
            month = datetime.strptime(month, "%Y-%m-%d").date()
            last_date_of_month = get_last_date_of_month(month)
            first_date_of_month = get_first_day_of_month(month)
            queryset = queryset.filter(working_day__gte=first_date_of_month, working_day__lte=last_date_of_month)
        if user_id:
            queryset = queryset.filter(user_id=user_id)

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

    @action(methods=['get'], detail=False, url_path='attendance-statistics-month')
    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter('user_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER, required=True),
        openapi.Parameter('month', openapi.IN_QUERY, type=openapi.TYPE_STRING, format=settings.DATE_FORMATS[0],
                          required=True),
    ])
    def detail_attendance_month(self, request, *args, **kwargs):
        queryset = AttendanceStatistics.objects.filter(deleted_at__isnull=True).order_by('-id')
        user_type = request.user.user_type
        if user_type == UserType.ADMIN.value:
            queryset = queryset
        else:
            if user_type == UserType.STAFF.value:
                queryset = queryset.filter(user=request.user)
            else:
                queryset = queryset_by_user_permission_to_object(request.user, queryset)
        month = request.query_params.get('month', None)
        user_id = request.query_params.get('user_id', None)
        if month:
            month = datetime.strptime(month, "%Y-%m-%d").date()
            print(month)

            queryset = queryset.filter(month=month)
            print(queryset)
        if user_id:
            queryset = queryset.filter(user_id=user_id)
        if queryset.count() > 0:
            serializer = AttendanceStatisticsSerializer(queryset.first())
            general_response = rsp.Response(serializer.data).generate_response()
        else:
            general_response = rsp.Response(None).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)


@method_decorator(name='list', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='partial_update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='retrieve', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='destroy', decorator=swagger_auto_schema(auto_schema=None))
class FaceAttendanceViewSet(GenericViewSet):
    permission_classes = []
    response_serializer_class = FaceAttendanceSerializer
    request_serializer_class = CreateFaceImageSerializer
    queryset = FaceAttendance.objects.filter(deleted_at__isnull=True)
    parser_classes = [MultiPartParser, FormParser]

    def create(self, request, *args, **kwargs):
        print('go heeeeeeeee create')
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


@method_decorator(name='create', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
@method_decorator(name='partial_update', decorator=swagger_auto_schema(auto_schema=None))
class FaceAttendanceView(GenericViewSet):
    serializer_class = FaceAttendanceSerializer
    queryset = FaceAttendance.objects.filter(deleted_at__isnull=True)
    parser_classes = [JSONParser]

    permission_action_classes = {
        'list': [IsAuthenticated],
        'retrieve': [PermissionAttendance],
        'destroy': [PermissionAttendance]
    }

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter('user_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('organization_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('branch_office_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('department_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('team_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('date', openapi.IN_QUERY, type=openapi.TYPE_STRING, format=settings.DATE_FORMATS[0]),
        openapi.Parameter('month', openapi.IN_QUERY, type=openapi.TYPE_STRING, format=settings.DATE_FORMATS[0]),
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
        date = request.query_params.get('date', None)
        month = request.query_params.get('month', None)

        queryset = filter_by_common_parameter(queryset, organization_id, branch_office_id, department_id, team_id)

        if user_id:
            queryset = queryset.filter(user_id=user_id)
        if date:
            date_format = settings.DATE_FORMATS[0]

            date = datetime.strptime(date, date_format)
            next_date = date + timedelta(days=1)
            previous_date = date - timedelta(days=1)
            queryset = queryset.filter(created_at__gt=previous_date, created_at__lt=next_date)

        if month:
            date_format = settings.DATE_FORMATS[0]

            month = datetime.strptime(month, date_format)
            last_date_month = get_last_date_of_month(month)
            next_month = last_date_month + timedelta(days=1)
            first_date_month = get_first_day_of_month(month)
            queryset = queryset.filter(created_at__gte=first_date_month, created_at__lt=next_month)

        serializer = self.serializer_class(queryset, many=True)
        general_response = rsp.Response(serializer.data).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)

    def destroy(self, request, *args, **kwargs):
        o = self.get_object()
        o.deleted_at = datetime.now()
        o.save()
        general_response = rsp.Response(None).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)
