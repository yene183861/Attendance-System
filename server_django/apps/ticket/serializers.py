import datetime
from rest_framework import serializers

from apps.attendance.models import Attendance
from apps.ticket_type.serializers import TicketReasonSerializer

from apps.user.serializers import UserSerializer

from apps.ticket.models import Ticket, DateTimeTicket
from apps.common.utils import *
from apps.common.constants import WorkType
from apps.user_work.models import UserWork
from apps.ticket_type.models import TicketReason
from apps.common.constants import TicketStatus, TicketType


class DateTimeTicketSerializer(serializers.ModelSerializer):
    ticket_reason = TicketReasonSerializer()

    class Meta:
        model = DateTimeTicket
        fields = (
            'id', 'ticket', 'start_date_time', 'end_date_time', 'ticket_reason')
        extra_kwargs = {
            'start_date_time': {'format': settings.DATE_TIME_FORMATS[0]},
            'end_date_time': {'format': settings.DATE_TIME_FORMATS[0]},
            # 'start_time': {'format': settings.TIME_FORMATS[0]},
            # 'end_time': {'format': settings.TIME_FORMATS[0]},
        }


class CreateDateTimeTicketSerializer(serializers.ModelSerializer):
    ticket_reason = serializers.PrimaryKeyRelatedField(queryset=TicketReason.objects.filter(deleted_at__isnull=True))

    class Meta:
        model = DateTimeTicket
        fields = ('start_date_time', 'end_date_time', 'ticket_reason')
        extra_kwargs = {
            'start_date_time': {'format': settings.DATE_TIME_FORMATS[0]},
            'end_date_time': {'format': settings.DATE_TIME_FORMATS[0]},
            # 'start_time': {'format': settings.TIME_FORMATS[0]},
            # 'end_time': {'format': settings.TIME_FORMATS[0]},
        }

    def validate(self, attrs):
        print('valide ticket datetime')
        ticket_type = self.context.get('request').data.get('ticket_type', None)
        print(self.context.get('request').data)
        print(f'ticket type: {ticket_type}')
        # if not ticket_type:
        #     print(self.context.get('view'))
        #     ticket_type = self.context.get('view').get_object().ticket_type
        user_request = self.context.get('request').user
        ticket_reason = attrs.get('ticket_reason')
        if ticket_reason.ticket_type != ticket_type:
            raise CustomException(ErrorCode.error_client, custom_message='ticket_reason is not belong to ticket_type')
        org = ticket_reason.organization
        user_work = UserWork.objects.filter(user=user_request, organization=org, deleted_at__isnull=True).first()
        if not user_work:
            print('ticket_reason không thuộc tổ chức của user request')
            raise CustomException(ErrorCode.error_not_permisstion)

        ticket_type = TicketType(ticket_reason.ticket_type)
        start_date_time = attrs.get('start_date_time')
        end_date_time = attrs.get('end_date_time')
        print('\n')
        print(ticket_type)
        if ticket_type != TicketType.APPLICATION_FOR_THOUGHT:
            if start_date_time.date() != end_date_time.date():
                raise CustomException(ErrorCode.error_json_parser,
                                      custom_message='end_date_time is the same day start_date_time')
        start_time = attrs.get('start_time')
        end_time = attrs.get('end_time')
        # if start_date > end_date:
        #     raise CustomException(ErrorCode.error_json_parser, custom_message='start_date must not after end_date')

        if start_date_time > end_date_time:
            raise CustomException(ErrorCode.error_json_parser,
                                  custom_message='start_date_time must not after end_date_time')
        print('validate done')
        return attrs


class TicketSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    reviewer = UserSerializer()
    date_time_tickets = serializers.SerializerMethodField()

    class Meta:
        model = Ticket
        fields = (
            'id', 'user', 'ticket_type', 'description', 'status', 'reviewer', 'reviewer_opinions', 'date_time_tickets',
            'created_at', 'updated_at')
        extra_kwargs = {
            'created_at': {'format': settings.DATE_TIME_FORMATS[0]},
            'updated_at': {'format': settings.DATE_TIME_FORMATS[0]},
        }

    def get_date_time_tickets(self, instance):
        data = DateTimeTicket.objects.filter(ticket=instance, deleted_at__isnull=True)
        serializer = DateTimeTicketSerializer(data, many=True)
        return serializer.data


class CreateTicketSerializer(serializers.ModelSerializer):
    date_time_tickets = CreateDateTimeTicketSerializer(many=True, required=True)

    class Meta:
        model = Ticket
        fields = ('ticket_type', 'description', 'date_time_tickets')

    def validate(self, attrs):
        attrs['user'] = self.context.get('request').user
        # user_request = self.context.get('request').user
        # if user_request.user_type == user.user_type:
        #     attrs.pop('reviewer_opinions')
        #     pass
        # elif user_request.user_type > user.user_type:
        #     raise CustomException(ErrorCode.error_not_permisstion)
        # else:
        #     check_user_under_management(user_request, user)
        #     attrs['status'] = TicketStatus.APPROVED.value
        #     attrs.pop('description')
        #     attrs['reviewer'] = user_request

        date_time_tickets = attrs.get('date_time_tickets', None)
        if not date_time_tickets:
            raise CustomException(ErrorCode.error_json_parser, custom_message='date_time_tickets is required')

        if len(date_time_tickets) == 0:
            raise CustomException(ErrorCode.error_json_parser, custom_message='ticket must have at least 1 claim time')
        valid = True

        for d in date_time_tickets:
            ticket_reason = d.get('ticket_reason')
            d['ticket_reason'] = ticket_reason.pk
            serializer = CreateDateTimeTicketSerializer(data=d, context={'request': self.context.get('request'),
                                                                         'view': self.context.get('view')})
            is_valid = serializer.is_valid(raise_exception=True)
            if not is_valid:
                valid = False
                break
            d['ticket_reason'] = ticket_reason

        if valid:
            return attrs

    def create(self, validated_data):
        date_time_tickets = validated_data.pop('date_time_tickets')
        ticket = Ticket.objects.create(**validated_data)
        for dt_data in date_time_tickets:
            DateTimeTicket.objects.create(ticket=ticket, **dt_data)
        return ticket


class UpdateTicketSerializer(serializers.ModelSerializer):
    date_time_tickets = CreateDateTimeTicketSerializer(many=True, required=False)

    class Meta:
        model = Ticket
        fields = ('ticket_type', 'status', 'description', 'date_time_tickets', 'reviewer_opinions')
        # extra_kwargs = {
        #     'date_time_tickets': {'required': False}
        # }

    def validate(self, attrs):

        user_request = self.context.get('request').user
        instance = self.context.get('view').get_object()
        attrs['ticket_type'] =instance.ticket_type
        if instance.user == user_request:
            if instance.status == TicketStatus.APPROVED.value:
                raise CustomException(ErrorCode.error_client,
                                      custom_message='Ticket has been approved, cannot be edited')
            attrs.pop('reviewer_opinions')
            attrs.pop('status')
            date_time_tickets = attrs.get('date_time_tickets', None)
            if date_time_tickets:
                if len(date_time_tickets) == 0:
                    raise CustomException(ErrorCode.error_json_parser,
                                          custom_message='ticket must have at least 1 claim time')
                else:
                    valid = True
                    for d in date_time_tickets:
                        ticket_reason = d.get('ticket_reason')
                        d['ticket_reason'] = ticket_reason.pk

                        serializer = CreateDateTimeTicketSerializer(data=d,
                                                                    context={'request': self.context.get('request'),
                                                                             'view': self.context.get('view')})

                        is_valid = serializer.is_valid(raise_exception=True)
                        if not is_valid:
                            valid = False
                            break
                        d['ticket_reason'] = ticket_reason
        else:
            reviewer = instance.reviewer
            if reviewer and user_request.user_type > reviewer.user_type:
                raise CustomException(ErrorCode.error_client,
                                      custom_message='Ticket has been approved or rejected by superiors, you cannot edit')
            has_permission = check_user_under_management(user_request, instance.user)
            if not has_permission:
                raise CustomException(ErrorCode.error_not_permisstion
                                      )
            attrs['reviewer'] = user_request
            attrs.pop('description')
            attrs.pop('date_time_tickets')
            status = attrs.get('status', None)
            if not status:
                raise CustomException(ErrorCode.error_client,
                                      custom_message='status is required')
            if status == TicketStatus.REFUSED.value:
                if not attrs.get('reviewer_opinions', None):
                    raise CustomException(ErrorCode.error_client,
                                          custom_message='Opinions is required for refused')
        return attrs

    def update(self, instance, validated_data):
        old_status = instance.status
        user_request = self.context.get('request').user
        if instance.user == user_request:
            date_time_tickets = validated_data.pop('date_time_tickets')
            if date_time_tickets:
                date_tickets = DateTimeTicket.objects.filter(ticket=instance, deleted_at__isnull=True)
                length = len(date_time_tickets)
                count = date_tickets.count()
                if length <= count:
                    ind = 0
                    for i in date_tickets:
                        if ind < length:
                            i.start_date_time = date_time_tickets[ind].get('start_date_time')
                            i.end_date_time = date_time_tickets[ind].get('end_date_time')
                            # i.start_time = date_time_tickets[ind].get('start_time')
                            # i.end_time = date_time_tickets[ind].get('end_time')
                            i.ticket_reason = date_time_tickets[ind].get('ticket_reason')

                            i.save()
                            ind = ind + 1
                        else:
                            i.deleted_at = datetime.datetime.now()
                            i.save()
                else:
                    ind = 0
                    for i in date_tickets:
                        i.start_date = date_time_tickets[ind].get('start_date')
                        i.end_date = date_time_tickets[ind].get('end_date')
                        i.start_time = date_time_tickets[ind].get('start_time')
                        i.end_time = date_time_tickets[ind].get('end_time')
                        i.ticket_reason = date_time_tickets[ind].get('ticket_reason')
                        i.save()
                        ind = ind + 1
                    date_time_tickets = date_time_tickets[ind:]
                    for ind in date_time_tickets:
                        DateTimeTicket.objects.create(ticket_id=instance.id, **ind)
            instance.description = validated_data.get('description', instance.description)
            instance.save()
        else:
            if validated_data.get('status', None):
                instance.status = validated_data.get('status')
            if validated_data.get('reviewer_opinions', None):
                instance.reviewer_opinions = validated_data.get('reviewer_opinions')
            instance.reviewer = validated_data.get('reviewer', instance.reviewer)
            instance.save()
        self.update_attendance(old_status, instance)
        return instance

    def update_attendance(self, old_status, instance):
        user = instance.user
        new_status = instance.status
        if old_status != new_status:
            print(f'old_status: {old_status} != new_status: {new_status}')
            ticket_type = instance.ticket_type
            if old_status != TicketStatus.APPROVED.value:
                print(f'old_status != TicketStatus.APPROVED.value')
                working_time = get_working_time_type(user)
                if new_status == TicketStatus.APPROVED.value:
                    print(f'new_status == TicketStatus.APPROVED.value')
                    datetime_tickets = DateTimeTicket.objects.filter(ticket_id=instance.id, deleted_at__isnull=True)

                    for dt in datetime_tickets:
                        start_date_time = dt.start_date_time
                        end_date_time = dt.end_date_time
                        start_time = start_date_time.time()
                        end_time = end_date_time.time()
                        start_date = start_date_time.date()
                        end_date = end_date_time.date()
                        ticket_reason = dt.ticket_reason
                        if ticket_type == TicketType.APPLICATION_FOR_THOUGHT.value:
                            print(' ticket_type == TicketType.APPLICATION_FOR_THOUGHT.value')
                            if start_date == end_date:
                                attendance = Attendance.objects.filter(user=user,
                                                                       working_day=start_date, deleted_at__isnull=True).filter()
                                working_time = get_working_time_type(user)
                                if not attendance:
                                    is_weekend = check_weekends_day(start_date)
                                    work_type = WorkType.WORK_DAY_OFF.value if is_weekend else WorkType.DAILY_WORK.value

                                    result = calculate_working_hours(start_time, end_time, working_time)
                                    print('\n')
                                    print('go herrre')
                                    a = Attendance.objects.create(user=user, work_type=work_type, status=True,
                                                                  start_time=start_date_time, end_time=end_date_time,
                                                                  working_day=start_date,
                                                                  is_late_in=result.get('is_late_in'),
                                                                  minutes_late_in=result.get('minutes_late_in'),
                                                                  is_early_out=result.get('is_early_out'),
                                                                  minutes_early_out=result.get('minutes_early_out'),
                                                                  work_number=result.get('work_number'),
                                                                  working_hours=result.get('working_hours'))

                                    print(a)
                                    a.tickets.add(instance)
                                    a.save()
                                else:
                                    start_time_attendance = attendance.start_time
                                    end_time_attendance = attendance.end_time

                                    result = calculate_working_hours(start_time, end_time, working_time)
                                    if not start_time_attendance and not end_time_attendance:
                                        # co don OT

                                        attendance.start_time = start_time
                                        attendance.end_time = end_time

                                        attendance.is_late_in = result.get('is_late_in')
                                        attendance.minutes_late_in = result.get('minutes_late_in')
                                        attendance.is_early_out = result.get('is_early_out')
                                        attendance.minutes_early_out = result.get('minutes_early_out')
                                        attendance.work_number = result.get('work_number')
                                        attendance.working_hours = result.get('working_hours')
                                        attendance.tickets.add(instance)
                                        attendance.save()
                                    else:
                                        break_time = working_time.break_time
                                        after_break_time = (
                                                combine_date_time(working_time.break_time) + timedelta(hours=1)).time()
                                        morning_shift = get_timedelta_between_days(working_time.start_time,
                                                                                   break_time).seconds // 60
                                        afternoon_shift = get_timedelta_between_days(working_time.end_time,
                                                                                     after_break_time).seconds // 60
                                        if not start_time_attendance or not end_time_attendance:
                                            attendance.working_hours = result.get('working_hours')
                                            attendance.work_number = result.get('work_number')
                                            is_late_in = result.get('is_late_in')
                                            is_early_out = result.get('is_early_out')
                                            if not end_time_attendance:
                                                attendance.end_time = end_time
                                                attendance.forgot_attendance = False
                                                if is_early_out:
                                                    attendance.is_early_out = is_early_out
                                                    attendance.minutes_early_out = result.get('minutes_early_out')
                                            else:
                                                if is_late_in:
                                                    attendance.is_late_in = is_late_in
                                                    attendance.minutes_late_in = result.get('minutes_late_in')

                                            attendance.tickets.add(instance)
                                            attendance.save()
                                        else:
                                            working_hours = attendance.working_hours + result.get('working_hours')
                                            attendance.working_hours = working_hours if working_hours <= 8.0 else 8.0
                                            attendance.work_number = result.get('work_number')
                                            attendance.end_time = end_time
                                            is_late_in = result.get('is_late_in')
                                            is_early_out = result.get('is_early_out')
                                            if is_late_in:
                                                attendance.is_late_in = is_late_in
                                                attendance.minutes_late_in = result.get('minutes_late_in')
                                            if is_early_out:
                                                attendance.is_early_out = is_early_out
                                                attendance.minutes_early_out = result.get('minutes_early_out')
                                            attendance.tickets.add(instance)
                                            attendance.save()

                        elif ticket_type == TicketType.APPLICATION_FOR_OVERTIME.value:
                            print(' ticket_type == TicketType.APPLICATION_FOR_OVERTIME.value')
                            # đơn tăng ca
                            hours = (end_date_time - start_date_time).seconds / 3600
                            attendance = Attendance.objects.filter(user=user,
                                                                   working_day=start_date, deleted_at__isnull=True).first()
                            is_weekend = check_weekends_day(start_date)
                            hours = get_timedelta_between_days(start_time, end_time).seconds / 3600
                            if attendance:
                                print('chấm công, thường là ngày thường')
                                print(attendance)
                                print(hours)
                                attendance.overtime_hour = hours
                                attendance.tickets.add(instance)
                                attendance.save()
                                print(attendance)
                            else:
                                print('ko chấm công, ngày cuối tuần hoặc ngày ko đi làm nhưng remote')
                                # ko chấm công, ngày cuối tuần hoặc ngày ko đi làm nhưng remote
                                a = Attendance.objects.create(user=user,
                                                              work_type=WorkType.WORK_DAY_OFF.value if is_weekend else WorkType.DAILY_WORK.value,
                                                              status=True, working_day=start_date,
                                                              overtime_hour=hours)
                                a.tickets.add(instance)
                                a.save()
                                print(a)
                        elif ticket_type == TicketType.CHECK_IN_OUT_FORM.value:
                            print(' ticket_type == TicketType.CHECK_IN_OUT_FORM.value')
                            attendance = Attendance.objects.filter(user=user,
                                                                   working_day=start_date, deleted_at__isnull=True)
                            if attendance:
                                print(attendance)
                                start_m_shift = datetime.time(10, 0, 0)
                                end_m_shift = datetime.time(12, 0, 0)
                                start_a_shift = datetime.time(14, 30, 0)
                                # end_a_shift = datetime.time(17, 30, 0)
                                m_check_in_form = check_time_before(start_time, start_m_shift)
                                if m_check_in_form:
                                    print('m_check_in_form')
                                    attendance.start_time = start_date_time
                                    result = calculate_working_hours(start_time, attendance.end_time.time(), working_time)
                                else:

                                    m_check_out_form = check_time_before(start_time, end_m_shift)
                                    if m_check_out_form:
                                        print('m_check_out_form')
                                        attendance.end_time = start_date_time
                                        result = calculate_working_hours(attendance.start_time.time(), start_time,
                                                                         working_time)
                                    else:
                                        a_check_in_form = check_time_before(start_time, start_a_shift)
                                        if a_check_in_form:
                                            print('a_check_in_form')
                                            attendance.start_time = start_date_time
                                            result = calculate_working_hours(start_time, attendance.end_time.time(),
                                                                             working_time)
                                        else:
                                            print(' not a_check_in_form')
                                            attendance.end_time = start_date_time
                                            result = calculate_working_hours(attendance.start_time.time(), start_time,
                                                                             working_time)
                                attendance.working_hours = result.get('working_hours')
                                attendance.work_number = result.get('work_number')
                                attendance.is_late_in = result.get('is_late_in')
                                attendance.minutes_late_in = result.get('minutes_late_in')
                                attendance.is_early_out = result.get('is_early_out')
                                attendance.minutes_early_out = result.get('minutes_early_out')
                                attendance.tickets.add(instance)
                                attendance.save()
                                print(attendance)
                        # update_statistics(attendance, user)

                else:

                    return

        else:
            return


