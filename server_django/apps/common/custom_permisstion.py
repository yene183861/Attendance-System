from rest_framework import permissions
from django.core.cache import cache
from apps.common.constants import UserType
from apps.common.utils import *
from apps.contract.models import Contract

from apps.user_work.models import UserWork
from django.db.models import Q


class IsSuperUser(permissions.BasePermission):

    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated and request.user.is_superuser and request.user.user_type == UserType.ADMIN.value


class IsAdminUser(permissions.BasePermission):

    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated and request.user.user_type == UserType.ADMIN.value


class IsCeoUser(permissions.BasePermission):

    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated and request.user.user_type == UserType.CEO.value


class IsDirectorUser(permissions.BasePermission):

    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated and request.user.user_type == UserType.DIRECTOR.value


class IsManagerUser(permissions.BasePermission):

    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated and request.user.user_type == UserType.MANAGER.value


class IsLeaderUser(permissions.BasePermission):

    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated and request.user.user_type == UserType.LEADER.value


class IsStaffUser(permissions.BasePermission):

    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated and request.user.user_type == UserType.STAFF.value


class IsCeoOrDirectorUser(permissions.BasePermission):

    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated and request.user.user_type <= UserType.DIRECTOR.value


class IsUserObject(permissions.BasePermission):

    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        return request.user == obj.user


class PermissionPayroll(permissions.BasePermission):

    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        if IsSuperUser().has_permission(request, view) or IsAdminUser().has_permission(request, view) \
                or obj.user == request.user:
            return True
        try:
            organization = UserWork.objects.filter(user=obj.user, deleted_at__isnull=True).first().organization

            UserWork.objects.filter(user=request.user, organization=organization, deleted_at__isnull=True).first()

            return True
        except UserWork.DoesNotExist:
            return False


class PermissionOwnerPayroll(permissions.BasePermission):

    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        if IsSuperUser().has_permission(request, view) or IsAdminUser().has_permission(request, view) \
                or obj.user == request.user:
            return True
        return False


class PermissionOrganization(permissions.BasePermission):

    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        if IsSuperUser().has_permission(request, view) or IsAdminUser().has_permission(request, view):
            return True
        try:
            UserWork.objects.filter(user=request.user, organization=obj, deleted_at__isnull=True).first()
            return True
        except UserWork.DoesNotExist:
            return False


class PermissionContract(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        if IsSuperUser().has_permission(request, view) or IsAdminUser().has_permission(request, view):
            return True

        user_request = request.user
        if user_request.user_type >= UserType.MANAGER.value:
            return obj.user == user_request
        else:

            t = UserWork.objects.filter(user=user_request, organization=obj.organization,
                                        deleted_at__isnull=True).first()
            if t:
                if user_request.user_type == UserType.CEO.value:
                    return True
                else:
                    user_work = UserWork.objects.filter(user=obj.user, deleted_at__isnull=True).first()
                    t = t.filter(branch_office=user_work.branch_office).first()
                    if t:
                        return True
                    return False
            return False
        return False


class PermissionRewardAndDiscipline(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        # là user admin hoặc user được thưởng/phạt
        if IsSuperUser().has_permission(request, view) or IsAdminUser().has_permission(request, view):
            return True
        else:
            print('go 123')
            # là user cấp cao hơn user của obj
            user = obj.user
            if user.user_type < request.user.user_type:
                print('user')
                return False

            try:
                print('test herre')
                t = check_user_under_management(request.user, user)
                print(t)
                return True
            except CustomException as e:
                return False


class PermissionTicketReason(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        if IsSuperUser().has_permission(request, view) or IsAdminUser().has_permission(request,
                                                                                       view):
            return True
        else:
            t = UserWork.objects.filter(user=request.user, organization=obj.organization,
                                        deleted_at__isnull=True).first()
            if t:
                return True
            return False


class PermissionTicket(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        if IsSuperUser().has_permission(request, view) or IsAdminUser().has_permission(request,
                                                                                       view) or request.user == obj.user:
            return True
        else:
            org = UserWork.objects.filter(user=obj.user,
                                          deleted_at__isnull=True).first().organization
            is_exist = UserWork.objects.filter(user=request.user, organization=org, deleted_at__isnull=True).first()
            if is_exist:
                return True
            return False


class PermissionRegisterFace(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        if IsSuperUser().has_permission(request, view) or IsAdminUser().has_permission(request,
                                                                                       view) or request.user == obj.user:
            return True
        else:
            org = UserWork.objects.filter(user=obj.user,
                                          deleted_at__isnull=True).first().organization
            is_exist = UserWork.objects.filter(user=request.user, organization=org, deleted_at__isnull=True).first()
            if is_exist:
                return True
            return False


class PermissionAttendance(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        if IsSuperUser().has_permission(request, view) or IsAdminUser().has_permission(request,
                                                                                       view) or request.user == obj.user:
            return True
        else:
            org = UserWork.objects.filter(user=obj.user,
                                          deleted_at__isnull=True).first().organization
            is_exist = UserWork.objects.filter(user=request.user, organization=org, deleted_at__isnull=True).first()
            if is_exist:
                return True
            return False


class HasPermissionBranchOffice(permissions.BasePermission):

    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        if IsSuperUser().has_permission(request, view) or IsAdminUser().has_permission(request, view):
            return True
        is_ceo = UserWork.objects.filter(user=request.user, user_type=UserType.CEO.value,
                                         organization=obj.organization).first()
        if is_ceo:
            return True
        else:
            try:
                UserWork.objects.filter(user=request.user, branch_office=obj).first()
                return True
            except UserWork.DoesNotExist:
                return False


class HasPermissionDepartment(permissions.BasePermission):

    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        if IsSuperUser().has_permission(request, view) or IsAdminUser().has_permission(request, view):
            return True

        is_ceo = UserWork.objects.filter(user=request.user, organization=obj.branch_office.organization,
                                         user_type=UserType.CEO.value).first()
        if is_ceo:
            return True

        is_director = UserWork.objects.filter(user=request.user, branch_office=obj.branch_office,
                                              user_type=UserType.DIRECTOR.value).first()
        if is_director:
            return True

        try:
            UserWork.objects.filter(user=request.user, department=obj).first()
            return True
        except UserWork.DoesNotExist:
            return False


class HasPermissionTeam(permissions.BasePermission):

    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        if IsSuperUser().has_permission(request, view) or IsAdminUser().has_permission(request, view):
            return True

        is_ceo = UserWork.objects.filter(user=request.user, organization=obj.department.branch_office.organization,
                                         user_type=UserType.CEO.value).first()
        if is_ceo:
            return True

        is_director = UserWork.objects.filter(user=request.user, branch_office=obj.department.branch_office,
                                              user_type=UserType.DIRECTOR.value).first()
        if is_director:
            return True

        is_manager = UserWork.objects.filter(user=request.user, department=obj.department.branch_office,
                                             user_type=UserType.MANAGER.value).first()
        if is_manager:
            return True

        try:
            UserWork.objects.filter(user=request.user, team=obj).first()
            return True
        except UserWork.DoesNotExist:
            return False


class HasPermissionAllowance(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        if IsSuperUser().has_permission(request, view) or IsAdminUser().has_permission(request, view):
            return True
        if request.user.user_type > UserType.DIRECTOR.value:
            return False
        is_ceo = UserWork.objects.filter(user=request.user, organization=obj.branch_office.organization,
                                         user_type=UserType.CEO.value).first()
        if is_ceo:
            return True

        is_director = UserWork.objects.filter(user=request.user, department=obj.branch_office,
                                              user_type=UserType.DIRECTOR.value).first()
        if is_director:
            return True
        return False


class HasPermissionWorkingTimeType(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        if IsSuperUser().has_permission(request, view) or IsAdminUser().has_permission(request, view):
            return True
        try:
            UserWork.objects.filter(user=request.user, organization=obj.organization).first()
            return True
        except UserWork.DoesNotExist:
            return False


class IsUserObjects(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        if IsSuperUser().has_permission(request, view) or IsAdminUser().has_permission(request, view):
            return True
        try:
            user_work = UserWork.objects.filter(user=obj).first()
            user_request_work = UserWork.objects.filter(user=request.user).first()
            if user_work.orgnization == user_request_work.organization:
                return True
            return False
        except UserWork.DoesNotExist:
            return False
