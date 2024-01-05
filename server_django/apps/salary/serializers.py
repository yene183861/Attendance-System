import datetime

from django.conf import settings
from rest_framework import serializers

from apps.allowance.models import Allowance
from apps.attendance.models import AttendanceStatistics, Attendance
from apps.common.constants import ContractStatus
from apps.common.error_code import ErrorCode
from apps.common.exception import CustomException
from apps.contract.models import Contract
from apps.reward_and_discipline.models import RewardOrDiscipline

from apps.user.serializers import UserCommonInfoSerializer

from apps.common.utils import check_user_under_management, get_last_date_of_month, \
    get_first_day_of_month, check_weekends_day, get_weekdays_count

from apps.salary.models import Payroll
from apps.user_work.models import UserWork


class PayrollSerializer(serializers.ModelSerializer):
    user = UserCommonInfoSerializer()

    class Meta:
        model = Payroll
        fields = ('id', 'user', 'month', 'real_field', 'total_salary', 'total_allowance', 'total_bonus', 'total_punish',
                  'insurance', 'tax', 'is_closed')
        extra_kwargs = {
            'month': {'format': settings.DATE_FORMATS[0]},
            'created_at': {'format': settings.DATE_TIME_FORMATS[0]},
            'updated_at': {'format': settings.DATE_TIME_FORMATS[0]},
        }


class CreatePayrollSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payroll
        fields = ('user', 'month')

    def validate(self, attrs):
        print(attrs.get('user'))
        user = attrs.get('user')
        print(user)
        month = attrs.get('month')
        user_request = self.context.get('request').user
        is_owner = user_request == user
        is_valid = check_user_under_management(user_request, user)
        if not (is_valid or is_owner):
            raise CustomException(ErrorCode.error_client, custom_message='Người dùng này kooong thuộc sự quản lý của bạn')
        return attrs

    def create(self, validated_data):

        # o = Payroll.objects.create(**validated_data)
        try:
            o = self.export_payroll(validated_data.get('user'), validated_data.get('month'))
        except CustomException as e:
            raise e
        if o:
            return o
        else:
            o= Payroll.objects.create(user=validated_data.get('user'), month=validated_data.get('month'))
            return o

    def export_payroll(self, user, month):
        payroll = Payroll.objects.filter(user=user, month=month, deleted_at__isnull=True).first()

        statistics = AttendanceStatistics.objects.filter(user=user, month=month, deleted_at__isnull=True).first()
        if not statistics:
            is_first_day_of_month = get_first_day_of_month(month)
            attendances = Attendance.objects.filter(user=user, working_day__gte=is_first_day_of_month,
                                                    status=True,
                                                    working_day__lte=month, deleted_at__isnull=True)
            if attendances.count() == 0:
                return None
            else:
                standard_work_number = get_weekdays_count(month)
                actual_work_number = 0
                times_late_in = 0
                minutes_late_in = 0
                times_early_out = 0
                minutes_early_out = 0
                off_without_reason = 0
                forgot_check_in_out = 0
                overtime_hour = 0
                # penalty_being_late = 0
                # early_return_penalty = 0
                # penalty_leaving_without_reason = 0
                # penalty_forgetting_attendance = 0
                ot_daily_work = 0
                ot_day_off = 0
                # ot_holiday = 0

                for item in attendances:
                    working_day = item.working_day
                    actual_work_number = actual_work_number + item.work_number
                    times_late_in = times_late_in + 1 if item.is_late_in else times_late_in
                    minutes_late_in = minutes_late_in + item.minutes_late_in if item.is_late_in else minutes_late_in
                    times_early_out = times_early_out + 1 if item.is_early_out else times_early_out
                    minutes_early_out = minutes_early_out + item.minutes_early_out if item.is_early_out else minutes_early_out
                    overtime_hour = overtime_hour + item.overtime_hour
                    is_weekends = check_weekends_day(working_day)
                    if is_weekends:
                        if item.overtime_hour != 0.0:
                            ot_day_off = ot_day_off + item.overtime_hour
                    else:
                        start_time = item.start_time
                        end_time = item.end_time
                        if not start_time and not end_time:
                            off_without_reason = off_without_reason + 1
                        else:
                            if not start_time or not end_time:
                                forgot_check_in_out = forgot_check_in_out + 1
                        if item.overtime_hour != 0.0:
                            ot_daily_work = ot_daily_work + item.overtime_hour
                statistics = AttendanceStatistics.objects.create(user=user, month=month,
                                                                 standard_work_number=standard_work_number,
                                                                 actual_work_number=actual_work_number,
                                                                 times_late_in=times_late_in,
                                                                 minutes_late_in=minutes_late_in,
                                                                 times_early_out=times_early_out,
                                                                 minutes_early_out=minutes_early_out,
                                                                 off_without_reason=off_without_reason,
                                                                 forgot_check_in_out=forgot_check_in_out,
                                                                 overtime_hour=overtime_hour,
                                                                 ot_daily_work=ot_daily_work,
                                                                 ot_day_off=ot_day_off)

        contract = Contract.objects.filter(user=user, deleted_at__isnull=True)
        contract_valid = contract.filter(state=ContractStatus.VALID_CONTRACT.value).first()
        if not contract_valid:
            contract_valid = contract.filter(
                state__in=[ContractStatus.EXPIRED_CONTRACT.value, ContractStatus.LIQUIDATION_CONTRACT.value]).order_by(
                '-updated_at').first()
            if not contract_valid:
                raise CustomException(ErrorCode.unknown_error,
                                      custom_message='Người dùng này không có hợp đồng hợp lệ nào với tổ chức')
        print(contract_valid)
        basic_salary = contract_valid.basic_salary
        print(contract_valid)
        salary_coefficient = contract_valid.salary_coefficient
        print(salary_coefficient)
        total_salary = basic_salary * salary_coefficient
        user_work = UserWork.objects.filter(user=user, deleted_at__isnull=True).first()
        total_allowance = 0
        total_bonus = 0
        total_punish = 0
        if user_work:
            a = Allowance.objects.filter(organization=user_work.organization, deleted_at__isnull=True)
            b = RewardOrDiscipline.objects.filter(user=user, deleted_at__isnull=True, month= month)
            if a.count() > 0:
                for i in a:
                    total_allowance = total_allowance + i.amount
            if b.count() > 0:
                for i in b:
                    if b.is_reward:
                        total_bonus = total_bonus + b.amount
                    else:
                        total_punish = total_punish + b.amount

        insurance = basic_salary * 0.105
        real_field = (total_salary + total_allowance - insurance) / statistics.standard_work_number * statistics.actual_work_number + total_bonus - total_punish
        tax = 0 if real_field <= 11000000 else real_field * 0.1
        real_field = real_field - tax
        if payroll:
            payroll.total_salary = total_salary
            payroll.total_allowance = total_allowance
            payroll.total_bonus = total_bonus
            payroll.total_punish = total_punish
            payroll.insurance = insurance
            payroll.tax = tax
            payroll.real_field = real_field
            payroll.save()
        else:
            payroll = Payroll.objects.create(user=user, month=month, total_salary=total_salary,
                                             total_allowance=total_allowance,
                                             total_bonus=total_bonus, total_punish=total_punish, insurance=insurance,
                                             tax=tax, real_field=real_field)
        return payroll


class UpdatePayrollSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payroll
        fields = ('real_field', 'total_salary', 'total_allowance', 'total_bonus', 'total_punish',
                  'insurance', 'tax', 'is_closed')

    def validate(self, attrs):
        instance = self.context.get('view').get_object()
        new_month = attrs.get('month', None)
        if new_month:
            new_month = get_last_date_of_month(new_month)
        month = instance.month
        now = get_last_date_of_month(datetime.datetime.now().date())
        if month <= now and (now - month).days > 5:
            raise CustomException(ErrorCode.error_client,
                                  custom_message='Last month\'s payroll is closed on the 5th of this month, cannot be edited')
        if new_month < now and (month - new_month).days > 5:
            raise CustomException(ErrorCode.error_client,
                                  custom_message='This month\'s payroll is closed, cannot be edited')
        amount = attrs.get('amount', instance.amount)

        if amount < 0:
            raise CustomException(ErrorCode.error_client, custom_message='amount must be positive')
        return attrs

    def update(self, instance, validated_data):

        return super().update(instance, validated_data)
