from django.utils.decorators import method_decorator
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework.parsers import MultiPartParser, JSONParser
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
import datetime

import apps.common.response_interface as rsp
from apps.common.view_helper import GenericViewSet, EmptySerializer
from apps.branch_office.serializers import BranchOfficeSerializer, CreateBranchOfficeSerializer
from apps.branch_office.models import BranchOffice
from apps.common.custom_permisstion import *
from apps.common.constants import UserType
from apps.working_time_setting.serializers import *
from apps.working_time_setting.models import *
from django.conf import  settings


@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
class WorkingTimeTypeViewSet(GenericViewSet):
    serializer_class = WorkingTimeTypeSerializer
    action_serializers = {
        'list_response': EmptySerializer,
        'create_request': CreateWorkingTimeTypeSerializer,
        'partial_update_request': CreateWorkingTimeTypeSerializer,
    }
    queryset = WorkingTimeType.objects.filter(deleted_at__isnull=True)
    parser_classes = [JSONParser]

    permission_action_classes = {
        'create': [IsSuperUser | IsAdminUser | IsCeoUser & HasPermissionWorkingTimeType],
        'list': [HasPermissionWorkingTimeType],
        'retrieve': [HasPermissionWorkingTimeType],
        'update': [IsSuperUser | IsAdminUser | IsCeoUser & HasPermissionWorkingTimeType],
        'destroy': [IsSuperUser | IsAdminUser | IsCeoUser & HasPermissionWorkingTimeType]
    }

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter('organization_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER, required=True)])
    def list(self, request, *args, **kwargs):
        user_type = request.user.user_type
        if user_type== UserType.ADMIN.value:
            queryset= self.queryset
        else:
            organization = UserWork.objects.filter(user=request.user).first().organization
            queryset = WorkingTimeType.objects.filter(organization=organization)

        query_params = request.query_params.get('organization_id', None)
        if query_params:
            queryset = queryset.filter(organization_id=query_params)

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
    
    def destroy(self, request, *args, **kwargs):
        o = self.get_object()
        if not o.default and o.status:
            o.deleted_at = datetime.datetime.now()
            o.save()
            general_response = rsp.Response(None).generate_response()
            return Response(general_response, status=status.HTTP_200_OK)
        else:
            raise CustomException(ErrorCode.error_client, custom_message='Please select another framework as default before deleting')


@method_decorator(name='update', decorator=swagger_auto_schema(auto_schema=None))
class WorkingTimeSettingViewSet(GenericViewSet):
    serializer_class = WorkingTimeSettingSerializer
    action_serializers = {
        'list_response': EmptySerializer,
        'create_request': CreateWorkingTimeSettingSerializer,
        'partial_update_request': CreateWorkingTimeSettingSerializer,
    }
    queryset = WorkingTimeSetting.objects.filter(deleted_at__isnull=True)
    parser_classes = [JSONParser]

    # permission_action_classes = {
    #     'create': [IsSuperUser | IsAdminUser | IsCeoUser & HasPermissionOrganigation],
    #     'list': [HasPermissionOrganigation],
    #     'retrieve': [HasPermissionOrganigation],
    #     'update': [IsSuperUser | IsAdminUser | IsCeoUser & HasPermissionOrganigation],
    #     'destroy': [IsSuperUser | IsAdminUser | IsCeoUser & HasPermissionOrganigation]
    # }

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter('working_time_type_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('user_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('organization_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('branch_office_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('department_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('team_id', openapi.IN_QUERY, type=openapi.TYPE_INTEGER),
        openapi.Parameter('status', openapi.IN_QUERY, type=openapi.TYPE_BOOLEAN),
        openapi.Parameter('start_date', openapi.IN_QUERY, type=openapi.TYPE_STRING, format=settings.DATE_FORMATS[0]),
        openapi.Parameter('end_date', openapi.IN_QUERY, type=openapi.TYPE_STRING, format=settings.DATE_FORMATS[0]),
    ])
    def list(self, request, *args, **kwargs):
        working_time_type_id = request.query_params.get('working_time_type_id', None)
        user_id = request.query_params.get('user_id', None)
        organization_id = request.query_params.get('organization_id', None)
        branch_office_id = request.query_params.get('branch_office_id', None)
        department_id = request.query_params.get('department_id', None)
        team_id = request.query_params.get('team_id', None)
        state = request.query_params.get('status', None)
        start_date = request.query_params.get('start_date', None)
        end_date = request.query_params.get('end_date', None)

        user_type = request.user.user_type
        if user_type == UserType.ADMIN.value:
            queryset = WorkingTimeSetting.objects.all()
        elif user_type == UserType.CEO.value:
            organization = UserWork.objects.filter(user = request.user).first().organization
            user_works = UserWork.objects.filter(organization=organization)
            users = [user_work.user for user_work in user_works]
            queryset = WorkingTimeSetting.objects.filter(user__in=users)
        elif user_type == UserType.DIRECTOR.value:
            branch_office = UserWork.objects.filter(user=request.user).first().branch_office
            user_works = UserWork.objects.filter(branch_office=branch_office)
            users = [user_work.user for user_work in user_works]
            queryset = WorkingTimeSetting.objects.filter(user__in=users)
        elif user_type == UserType.MANAGER.value:
            department = UserWork.objects.filter(user=request.user).first().department
            user_works = UserWork.objects.filter(department=department)
            users = [user_work.user for user_work in user_works]
            queryset = WorkingTimeSetting.objects.filter(user__in=users)
        elif user_type == UserType.LEADER.value:
            team = UserWork.objects.filter(user=request.user).first().team
            user_works = UserWork.objects.filter(team=team)
            users = [user_work.user for user_work in user_works]
            queryset = WorkingTimeSetting.objects.filter(user__in=users)

        if working_time_type_id:
            queryset = queryset.filter(setting_type_id=working_time_type_id)

        if user_id:
            queryset = queryset.filter(user_id=user_id)
        if organization_id:
            user_works = UserWork.objects.filter(organization_id=organization_id)
            users = [user_work.user for user_work in user_works]
            queryset = queryset.filter(user__in=users)
        if branch_office_id:
            user_works = UserWork.objects.filter(branch_office_id=branch_office_id)
            users = [user_work.user for user_work in user_works]
            queryset = queryset.filter(user__in=users)
        if department_id:
            user_works = UserWork.objects.filter(department_id=department_id)
            users = [user_work.user for user_work in user_works]
            queryset = queryset.filter(user__in=users)
        if team_id:
            user_works = UserWork.objects.filter(team_id=team_id)
            users = [user_work.user for user_work in user_works]
            queryset = queryset.filter(user__in=users)
        if state:
            queryset = queryset.filter(status=state)
        if start_date:
            start_date = datetime.strptime(start_date, settings.DATE_FORMATS[0])
            queryset = queryset.filter(start_date__gte=start_date)
        if end_date:
            end_date = datetime.strptime(end_date, settings.DATE_FORMATS[0])
            queryset = queryset.filter(end_date__lte=end_date)

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

    def destroy(self, request, *args, **kwargs):
        o = self.get_object()
        o.deleted_at = datetime.datetime.now()
        o.save()
        general_response = rsp.Response(None).generate_response()
        return Response(general_response, status=status.HTTP_200_OK)