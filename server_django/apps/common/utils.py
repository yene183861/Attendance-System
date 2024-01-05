import re
import random
import os
from datetime import datetime, timedelta
import numpy as np
from django.conf import settings
import math
import glob
from django.db.models import Q


from apps.common.constants import UserType
from apps.common.error_code import ErrorCode
from apps.common.exception import CustomException
from apps.user_work.models import UserWork
from apps.working_time_setting.models import WorkingTimeSetting, WorkingTimeType


def check_date_format(date_string):
    pattern = r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}(:\d{2}(\.\d{1,6})?)?(Z|[+-]\d{2}:\d{2})?$'
    match = re.match(pattern, date_string)
    return bool(match)


def get_timedelta_between_days(start_time: object = None, end_time: object = None, start_date: object = None,
                               end_date: object = None) -> object:
    if start_date is None:
        start_date = datetime.today().date()
    if end_date is None:
        end_date = datetime.today().date()
    if start_time is None:
        end_date = datetime.now().time()
    if end_time is None:
        end_date = datetime.now().time()

    start_datetime = datetime.combine(start_date, start_time)
    end_datetime = datetime.combine(end_date, end_time)
    time_difference = end_datetime - start_datetime
    return time_difference


def get_first_day_of_month(date):
    date = date.replace(day=1)
    return date


def get_last_date_of_month(date):
    last_month = date.replace(day=1, month=date.month + 1 if date.month < 12 else 1,
                              year=date.year if date.month < 12 else date.year + 1)
    this_month = last_month - timedelta(days=1)
    return this_month


def get_weekdays_count(date):
    month = date.replace(day=1)
    next_month = month.replace(month=month.month + 1)
    count = np.busday_count(month, next_month)
    return int(count)


def get_salary_one_working_day(amount, weekdays_in_month):
    if not isinstance(amount, (int, float)) or amount < 0:
        raise ValueError('amount must be a number not less than 0')
    if not isinstance(weekdays_in_month, int) or weekdays_in_month <= 0:
        raise ValueError('weekdays in month must be a number not less than 0')
    return amount / weekdays_in_month


def check_weekends_day(date):
    weekday = date.weekday()
    if weekday < 5:
        return False
    else:
        return True


def is_valid_work(attrs, organization, user_type):
    branch_office = attrs.get('branch_office', None)
    department = attrs.get('department', None)
    team = attrs.get('team', None)

    if branch_office and branch_office.organization != organization:
        return 'The branch \'{}\' is not part of the organization \'{}\''.format(branch_office.name, organization.name)
    if not department:
        return None
    else:
        if user_type >= UserType.MANAGER.value and department.branch_office != branch_office:
            return 'The department \'{}\' is not part of the branch office \'{}\''.format(department.name,
                                                                                          branch_office.name)
    if not team:
        return None
    else:
        if user_type >= UserType.LEADER.value and team.department != department:
            return 'The team \'{}\' is not part of the department \'{}\''.format(team.name, department.name)
    return None


def get_working_time_type(user):
    working_time = WorkingTimeSetting.objects.filter(user=user, status=True).first()
    if not working_time:
        organization = UserWork.objects.filter(user=user).first().organization
        working_time = WorkingTimeType.objects.filter(organization=organization, default=True).first()
    else:
        working_time = working_time.setting_type
    return working_time


def queryset_by_user_permission_to_object(user_request, queryset):
    user_type = user_request.user_type
    if user_type == UserType.STAFF.value:
        queryset = queryset.filter(user=user_request)
        return queryset
    if user_type == UserType.CEO.value:
        organization = UserWork.objects.filter(deleted_at__isnull=True, user=user_request).first().organization
        user_works = UserWork.objects.filter(deleted_at__isnull=True, organization=organization)
        users = [user_work.user for user_work in user_works]
    elif user_type == UserType.DIRECTOR.value:
        branch_office = UserWork.objects.filter(deleted_at__isnull=True, user=user_request).first().branch_office
        user_works = UserWork.objects.filter(deleted_at__isnull=True, branch_office=branch_office)
        users = [user_work.user for user_work in user_works]
    elif user_type == UserType.MANAGER.value:
        department = UserWork.objects.filter(deleted_at__isnull=True, user=user_request).first().department
        user_works = UserWork.objects.filter(deleted_at__isnull=True, department=department)
        users = [user_work.user for user_work in user_works]
    elif user_type == UserType.LEADER.value:
        team = UserWork.objects.filter(deleted_at__isnull=True, user=user_request).first().team
        user_works = UserWork.objects.filter(deleted_at__isnull=True, team=team)
        users = [user_work.user for user_work in user_works]
    queryset = queryset.filter(user__in=users)
    return queryset


def filter_by_common_parameter(queryset, organization_id, branch_office_id, department_id, team_id):
    queryset = queryset
    if organization_id:
        queryset = queryset.filter(organization_id=organization_id)
    if branch_office_id:
        user_works = UserWork.objects.filter(deleted_at__isnull=True, branch_office_id=branch_office_id)
        users = [user_work.user for user_work in user_works]
        queryset = queryset.filter(user__in=users)
    if department_id:
        user_works = UserWork.objects.filter(deleted_at__isnull=True, department_id=department_id)
        users = [user_work.user for user_work in user_works]
        queryset = queryset.filter(user__in=users)
    if team_id:
        user_works = UserWork.objects.filter(deleted_at__isnull=True, team_id=team_id)
        users = [user_work.user for user_work in user_works]
        queryset = queryset.filter(user__in=users)
    return queryset


def filter_by_common_parameter_not_field_in_object(queryset, organization_id, branch_office_id, department_id, team_id):
    queryset = queryset
    if organization_id:
        queryset = queryset.filter(Q(user__userwork__organization_id=organization_id))
    if branch_office_id:
        queryset = queryset.filter(Q(user__userwork__branch_office_id=branch_office_id))
    if department_id:
        queryset = queryset.filter(Q(user__userwork__department_id=department_id))
    if team_id:
        queryset = queryset.filter(Q(user__userwork__team_id=team_id))
    return queryset


def check_user_under_management(user_request, user):
    if user_request.user_type != UserType.ADMIN.value:
        user_work = UserWork.objects.filter(user=user, deleted_at__isnull=True).first()
        user_request_work = UserWork.objects.filter(user=user_request, deleted_at__isnull=True).first()

        if user_work.organization != user_request_work.organization:
            raise CustomException(ErrorCode.error_not_permisstion)

        branch = user_request_work.branch_office
        if branch and user_work.branch_office != branch:
            raise CustomException(ErrorCode.error_not_permisstion)

        department = user_request_work.department
        if department and user_work.department != department:
            raise CustomException(ErrorCode.error_not_permisstion)

        team = user_request_work.team
        if team and user_work.team != team:
            raise CustomException(ErrorCode.error_not_permisstion)
    return True


def get_random_image(user_id):
    image_dir = settings.MEDIA_ROOT + f'/Dataset/raw/{user_id}/'

    image_files = glob.glob(image_dir + '*.png')
    if image_files:
        random_image_path = random.choice(image_files)
    else:
        random_image_path = None

    return random_image_path


def add_time_object_time(time, seconds_add):
    created_at_time = time
    created_at_datetime = datetime.combine(datetime.today(), created_at_time)
    ten_hours_timedelta = timedelta(seconds=seconds_add)
    result_datetime = created_at_datetime + ten_hours_timedelta
    result_time = result_datetime.time()
    return result_time


def get_image_url_from_path(absolute_path):
    relative_path = os.path.relpath(absolute_path, settings.MEDIA_ROOT)
    t = relative_path.replace('\\', '/')
    return f"{settings.MEDIA_URL}{t}"


def combine_date_time(time, date=None):
    if not date:
        date = datetime.now().date()
    return datetime.combine(date, time)


def calculate_working_hours(start_time, end_time, working_time):
    print('calculate_working_hours')
    break_time = working_time.break_time
    after_break_time = (combine_date_time(working_time.break_time) + timedelta(hours=1)).time()
    w_start_time = working_time.start_time
    w_end_time = working_time.end_time
    morning_shift = math.ceil(get_timedelta_between_days(w_start_time, break_time).seconds / 60)
    afternoon_shift = math.ceil(get_timedelta_between_days(after_break_time, w_end_time).seconds / 60)
    result = {'is_late_in': False, 'minutes_late_in': 0, 'is_early_out': False,
              'minutes_early_out': 0, 'work_number': 0.0, 'working_hours': 0.0}
    s_time = start_time
    e_time = end_time
    is_late_in = False
    minutes_late_in = 0
    is_early_out = False
    minutes_early_out = 0
    if not start_time or not end_time:
        if s_time:
            res = calculate_check_in_late(s_time, w_start_time, break_time, after_break_time, morning_shift)
            is_late_in = True if res.get('minutes_late_in') > 0 else False
            minutes_late_in = res.get('minutes_late_in')
        else:
            res = calculate_check_out_early(e_time, w_end_time, break_time, after_break_time, afternoon_shift)
            is_early_out = True if res.get('minutes_early_out') > 0 else False
            minutes_early_out = res.get('minutes_early_out')

        result['is_late_in'] = is_late_in
        result['minutes_late_in'] = minutes_late_in
        result['is_early_out'] = is_early_out
        result['minutes_early_out'] = minutes_early_out
        return result
    else:
        if start_time >= w_end_time or end_time <= w_start_time or break_time <= start_time <= end_time <= after_break_time:
            result['is_late_in'] = True
            result['minutes_late_in'] = morning_shift
            result['is_early_out'] = True
            result['minutes_early_out'] = afternoon_shift
            return result
        else:
            res = calculate_check_in_late(s_time, w_start_time, break_time, after_break_time, morning_shift)
            is_late_in = True if res.get('minutes_late_in') > 0 else False
            minutes_late_in = res.get('minutes_late_in')
            s_time = res.get('start_time')

            res = calculate_check_out_early(e_time, w_end_time, break_time, after_break_time, afternoon_shift)
            is_early_out = True if res.get('minutes_early_out') > 0 else False
            minutes_early_out = res.get('minutes_early_out')
            e_time = res.get('end_time')

            hours = get_timedelta_between_days(s_time, e_time).seconds / 3600
            if s_time <= break_time < after_break_time <= e_time:
                hours = hours - 1

            result['is_late_in'] = is_late_in
            result['minutes_late_in'] = minutes_late_in
            result['is_early_out'] = is_early_out
            result['minutes_early_out'] = minutes_early_out

            if e_time <= break_time:
                result['work_number'] = 0.5
                result['working_hours'] = hours

            elif s_time >= after_break_time:
                result['work_number'] = 0.5
                result['working_hours'] = hours
            else:
                result['work_number'] = 1.0
                result['working_hours'] = hours
            print(result)
            return result


def calculate_check_in_late(time, start_time, break_time, after_break_time, morning_shift):
    result = {'minutes_late_in': 0, 'start_time': time}
    minutes_late_in = 0
    s_time = time

    if time <= start_time:
        s_time = start_time
    elif break_time < time <= after_break_time:
        s_time = after_break_time
        minutes_late_in = morning_shift
    elif time <= break_time:
        minutes_late_in = math.ceil(get_timedelta_between_days(start_time, time).seconds / 60)

        if minutes_late_in <= 10:
            minutes_late_in = 0
    else:
        minutes_late_in = morning_shift + math.ceil(get_timedelta_between_days(after_break_time, time).seconds / 60)
    result['minutes_late_in'] = minutes_late_in
    result['start_time'] = s_time
    return result


def calculate_check_out_early(time, end_time, break_time, after_break_time, afternoon_shift):
    result = {'minutes_early_out': 0, 'end_time': time}
    minutes_early_out = 0
    e_time = time
    if break_time <= e_time <= after_break_time:
        e_time = break_time
        minutes_early_out = afternoon_shift
    elif e_time >= end_time:
        e_time = end_time
    elif e_time <= break_time:
        minutes_early_out = afternoon_shift + math.ceil(get_timedelta_between_days(e_time, break_time).seconds / 60)

    else:
        minutes_early_out = math.ceil(get_timedelta_between_days(e_time, end_time).seconds / 60)
        if minutes_early_out <= 10:
            minutes_early_out = 0
    result['minutes_early_out'] = minutes_early_out
    result['end_time'] = e_time
    return result


def check_time_before(start_time, end_time):
    today = datetime.today()
    start_datetime = datetime.combine(today, start_time)
    end_datetime = datetime.combine(today, end_time)
    return start_datetime <= end_datetime


# def update_statistics( attendance, user):
#         print('update_statistics')
#         last_date_of_month = get_last_date_of_month(attendance.working_day)
#         statics = AttendanceStatistics.objects.filter(user=user, month=last_date_of_month,
#                                                       deleted_at__isnull=True).first()
#         if statics:
#             print('statics has exist')
#             print(statics)
#             if attendance.is_late_in:
#                 statics.times_late_in = statics.times_late_in + 1
#                 statics.minutes_late_in = statics.minutes_late_in + attendance.minutes_late_in
#             if attendance.is_early_out:
#                 statics.times_early_out = statics.times_early_out + 1
#                 statics.minutes_early_out = statics.minutes_early_out + attendance.minutes_early_out
#             statics.save()
#         else:
#             print('statics not has exist')
#             data = {'user': user.id, 'month': attendance.working_day,
#                     'times_late_in': 1 if attendance.is_late_in else 0,
#                     'minutes_late_in': 0 if not attendance.is_late_in else attendance.minutes_late_in,
#                     'times_early_out': 1 if attendance.is_early_out else 0,
#                     'minutes_early_out': 0 if not attendance.is_early_out else attendance.minutes_early_out,
#                     }
#             print(data)
#             serializer = AttendanceStatisticsSerializer(data=data)
#             serializer.is_valid()
#             statics = serializer.save()
#         return statics
#
