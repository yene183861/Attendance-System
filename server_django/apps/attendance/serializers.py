import datetime

from rest_framework import serializers

from apps.attendance.models import *
from apps.ticket.serializers import TicketSerializer
from apps.common.constants import TicketStatus
from apps.user.serializers import UserCommonInfoSerializer, UserSerializer
from apps.attendance.recognization import recognization_user
from apps.common.utils import *


class FaceAttendanceSerializer(serializers.ModelSerializer):
    user = UserCommonInfoSerializer()
    image = serializers.SerializerMethodField()

    class Meta:
        model = FaceAttendance
        fields = ['id', 'user', 'image', 'status', 'created_at']
        extra_kwargs = {
            'created_at': {'format': settings.DATE_TIME_FORMATS[0]}
        }

    def get_image(self, instance):
        if instance.image:
            path = instance.image.url
            path = get_image_url_from_path(path)
            protocol = 'http'
            t = f'{protocol}://192.168.0.108:8000{path}'
            print(t)
            return t

        else:
            return None




class CreateFaceImageSerializer(serializers.Serializer):
    images = serializers.ListField(
        child=serializers.ImageField(max_length=1000000, allow_empty_file=False, use_url=False),
        write_only=True)

    def validate(self, attrs):
        images = attrs.get('images', None)
        if not images:
            raise CustomException(ErrorCode.error_client, custom_message='images is required')
        if len(images) < 1:
            raise CustomException(ErrorCode.error_client, custom_message='Required at least 1 images')

        result = recognization_user(images)
        print('result recognization user: ', result)

        if isinstance(result, bool):
            raise CustomException(ErrorCode.error_client, custom_message='Không thể nhận diện được gương mặt')

        try:
            result = int(result)
        except ValueError:
            raise CustomException(ErrorCode.error_client, custom_message='Không thể nhận diện được gương mặt')
        attrs['user_id'] = result
        attrs['images'] = images
        return attrs

    def create(self, validated_data):
        user_id = validated_data.get('user_id')
        user = User.object.get(pk=user_id)

        images = validated_data.get('images')
        now_date = datetime.now().date()
        is_weekend = check_weekends_day(now_date)
        print('is_weekend: ', is_weekend)
        face_attendance = FaceAttendance.objects.create(user=user, image=images[0])

        # if is_weekend:
        #     return face_attendance
        # else:
        attendance = Attendance.objects.filter(user=user, working_day=now_date, deleted_at__isnull=True).first()

        working_time = get_working_time_type(user)
        start_m_shift = working_time.start_time
        end_m_shift = working_time.break_time
        start_a_shift = datetime.combine(now_date, end_m_shift) + timedelta(hours=1)
        start_a_shift = start_a_shift.time()
        end_a_shift = working_time.end_time

        if attendance and (attendance.start_time or attendance.end_time):
            print('Đã chấm công trong ngày hoặc đã có bản ghi do duyệt đơn từ')
            start_time = attendance.start_time
            e_time = attendance.end_time
            end_time = face_attendance.created_at
            if start_time:
                attendance.end_time = end_time
            else:
                attendance.start_time = e_time
                attendance.end_time = end_time
            res = calculate_working_hours(attendance.start_time.time(), attendance.end_time.time(), working_time)
            print('\n')
            print(res)
            attendance.is_late_in = res.get('is_late_in')
            attendance.minutes_late_in = res.get('minutes_late_in')
            attendance.is_early_out = res.get('is_early_out')
            attendance.minutes_early_out = res.get('minutes_early_out')
            attendance.working_hours = res.get('working_hours')
            attendance.work_number = res.get('work_number')
            attendance.face_attendances.add(face_attendance)
            attendance.save()


            #         attendance.end_time = None
            #         attendance.save()
            #         start_time = attendance.start_time
            #     end_time = face_attendance.created_at
            #     print(f'end_time: {end_time}')
            #
            #     # if end_time > working_time.end_time:
            #     #     attendance.end_time = end_time
            #     #     attendance.is_early_out = False
            #     #     attendance.minutes_early_out = 0
            #     #     attendance.work_number = 1
            #     #     attendance.working_hours = calculate_working_hours(start_time, end_time, working_time)
            #     #     attendance.face_attendances.add(face_attendance)
            #     #     attendance.save()
            #     # else:
            #
            #     # check_out = check_out_attendance_on_time(end_time, working_time)
            #     # is_early_out = check_out.get('is_early_out')
            #     # minutes_early_out = check_out.get('minutes_early_out')
            #     # break_time = working_time.break_time
            #     #
            #     # my_datetime = datetime.combine(datetime.today(), break_time)
            #     # result_datetime = my_datetime + timedelta(hours=1)
            #     #
            #     # after_break_time = result_datetime.time()
            #     #
            #     # if start_time < working_time.start_time:
            #     #     start_time = working_time.start_time
            #     #
            #     # if end_time > working_time.end_time:
            #     #     end_time = working_time.end_time
            #     #
            #     # working_hours = get_timedelta_between_days(start_time, end_time).seconds / 3600
            #     # if start_time <= break_time:
            #     #     print('start_time <= break_time')
            #     #     if end_time >= after_break_time:
            #     #         print('end_time >= after_break_time')
            #     #         working_hours = working_hours - 1
            #     #     elif end_time <= break_time:
            #     #         print('end_time <= break_time')
            #     #         pass
            #     #     else:
            #     #         print('break_time < end_time < after_break_time')
            #     #         working_hours = get_timedelta_between_days(start_time, break_time).seconds / 3600
            #     # elif start_time >= after_break_time:
            #     #     print('start_time >= after_break_time')
            #     #     pass
            #     # else:
            #     #     print('break_time < start_time < after_break_time')
            #     #     if break_time < end_time <= after_break_time:
            #     #         print('break_time < end_time <= after_break_time')
            #     #         working_hours = 0
            #     #     else:
            #     #         print(' end_time > after_break_time')
            #     #         working_hours = get_timedelta_between_days(after_break_time, break_time).seconds / 3600
            #     # work_number = 1
            #     # if attendance.is_late_in:
            #     #     if attendance.minutes_late_in <= 105:
            #     #         work_number = 0.75
            #     #     else:
            #     #         work_number = 0.5
            #     # if is_early_out:
            #     #     if minutes_early_out <= 105:
            #     #         work_number = work_number - 0.25
            #     #     else:
            #     #         work_number = work_number - 0.5
            #
            #     # attendance.end_time = end_time
            #     # attendance.is_early_out = is_early_out
            #     # attendance.minutes_early_out = minutes_early_out
            #     # attendance.work_number = work_number
            #     # attendance.working_hours = working_hours
            #     # attendance.face_attendances.add(face_attendance)
            #     # attendance.save()
            #     # self.update_statistics(attendance, user)
            #     result = calculate_working_hours(start_time.time(), end_time.time(), working_time)
            #     print('\n')
            #     print(f'result: {result}')
            #
            #     attendance.end_time = end_time
            #     attendance.is_late_in = result.get('is_late_in')
            #     attendance.minutes_late_in = result.get('minutes_late_in')
            #     attendance.is_early_out = result.get('is_early_out')
            #     attendance.minutes_early_out = result.get('minutes_early_out')
            #     attendance.work_number = result.get('work_number')
            #     attendance.working_hours = result.get('working_hours')
            #     attendance.face_attendances.add(face_attendance)
            #     attendance.save()
            #     print('\n')
            #     print(attendance)
            #     # self.update_statistics(attendance, user)
            #
        else:
            print('Chưa chấm công trong ngày or duyệt đơn từ làm thêm')
            start_time = face_attendance.created_at
            check = check_time_before(start_time.time(), start_m_shift)
            s_time = None
            e_time = None
            if check:
                s_time = start_time
            else:
                t = get_timedelta_between_days(start_m_shift, start_time.time()).seconds // 60
                if t <= 150:
                    s_time = start_time
                else:
                    e_time = start_time
            s = None
            e = None
            if s_time:
                s = s_time.time()
            if e_time:
                e = e_time.time()
            res = calculate_working_hours(s, e, working_time)
            attendance = Attendance.objects.create(user=user, start_time=s_time,
                                                   working_day=now_date,
                                                   is_late_in=res.get('is_late_in'),
                                                   minutes_late_in=res.get('minutes_late_in'),
                                                   is_early_out=res.get('is_early_out'),
                                                   minutes_early_out=res.get('minutes_early_out'),
                                                   end_time=e_time)
            attendance.face_attendances.add(face_attendance)
            attendance.save()
        # update_statistics(attendance, user)
        return face_attendance


class AttendanceSerializer(serializers.ModelSerializer):
    face_attendances = FaceAttendanceSerializer(many=True, read_only=True)
    tickets = TicketSerializer(many=True, read_only=True)
    user = UserSerializer()

    class Meta:
        model = Attendance
        fields = ['id', 'user', 'work_type', 'status', 'start_time', 'end_time', 'working_hours', 'work_number',
                  'working_day', 'is_late_in',
                  'minutes_late_in', 'is_early_out', 'minutes_early_out', 'tickets', 'face_attendances',
                  'overtime_hour']
        extra_kwargs = {
            'working_day': {'format': settings.DATE_FORMATS[0]},
            'start_time': {'format': settings.DATE_TIME_FORMATS[0]},
            'end_time': {'format': settings.DATE_TIME_FORMATS[0]},
        }

    def get_face_attendances(self, instance):
        faces = FaceAttendance.objects.filter(user=instance.user, created_at__year=instance.working_day.year,
                                              created_at__month=instance.working_day.month,
                                              created_at__day=instance.working_day.day).all()
        if not faces:
            return None
        serializer = FaceAttendanceSerializer(faces, many=True)
        return serializer.data

    def get_tickets(self, instance):
        tickets = Ticket.objects.filter(user=instance.user, status=TicketStatus.APPROVED.value,
                                        start_date__lte=instance.working_day,
                                        created_at__month=instance.working_day.month,
                                        end_date__gte=instance.working_day).all()
        # .include(
        # ticket_type=TicketType.APPLICATION_FOR_OVERTIME.value).all()
        if not tickets:
            return None
        serializer = TicketSerializer(tickets, many=True)
        return serializer.data


# cho việc tạo công bổ sung

class CreateAttendanceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Attendance
        fields = ['user', 'work_type', 'start_time', 'end_time', 'status', 'working_day', 'overtime_hour']
        extra_kwargs = {
            'working_day': {'format': settings.DATE_FORMATS[0]},
            'start_time': {'format': settings.DATE_TIME_FORMATS[0]},
            'end_time': {'format': settings.DATE_TIME_FORMATS[0], 'required': True},
        }

    def validate(self, attrs):
        start_time = attrs.get('start_time', None)
        end_time = attrs.get('end_time', None)
        if end_time < start_time:
            raise CustomException(ErrorCode.error_client,
                                  custom_message='end_time must be greater than start_time')

        work_type = attrs.get('work_type', None)

        return attrs

    def create(self, validated_data):
        attendance = Attendance.objects.create(**validated_data)
        return attendance

    def update(self, instance, validated_data):
        validated_data.pop('user')
        return super().update(instance, **validated_data)

class AttendanceStatisticsSerializer(serializers.ModelSerializer):
    class Meta:
        model = AttendanceStatistics
        fields = ['id', 'user', 'month', 'standard_work_number', 'actual_work_number', 'times_late_in',
                  'minutes_late_in',
                  'times_early_out',
                  'minutes_early_out', 'off_without_reason', 'forgot_check_in_out', 'overtime_hour',
                  'penalty_being_late', 'early_return_penalty', 'penalty_leaving_without_reason',
                  'penalty_forgetting_attendance', 'is_closed', 'ot_daily_work', 'ot_day_off', 'ot_holiday']
        extra_kwargs = {
            'month': {'format': settings.DATE_FORMATS[0]},
        }

    def create(self, validated_data):
        month = validated_data.get('month')
        count = get_weekdays_count(month)
        validated_data['standard_work_number'] = count
        return super().create(validated_data)
