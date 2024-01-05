from django.db import models
from apps.authentication.models import User
from apps.department.models import Department
from apps.organization.models import Organization
from apps.common.models import CommonModel, TrimmedCharFieldModel
from django.core.validators import MaxValueValidator, MinValueValidator
from apps.ticket.models import Ticket
from datetime import datetime
import os
from django.conf import settings
from apps.common.constants import WorkType


def image_path():
    date_format = datetime.now().strftime('%Y%m%d')
    upload_dir = f'attendances/{date_format}'
    path = os.path.join(settings.MEDIA_ROOT, upload_dir)
    if not os.path.exists(path):
        os.makedirs(path)
    return upload_dir


# model lưu trữ ảnh đơn
# class FaceImage(CommonModel):
#     img = models.ImageField(upload_to=image_path())
#
#
#     class Meta:
#         db_table = 'face_image'


class FaceAttendance(CommonModel):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='face_attendance')
    image = models.FileField(upload_to=image_path())
    status = models.BooleanField(default=True)

    class Meta:
        db_table = 'face_attendance'


class Attendance(CommonModel):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='attendance')
    # kiểu công: ngày lễ, ngày làm việc bình thường, OT...
    work_type = models.IntegerField(choices=WorkType.choices(), default=WorkType.DAILY_WORK.value)
    # trạng thái công: hợp lệ, ko hợp lệ
    status = models.BooleanField(default=True)
    # số giờ làm việc
    start_time = models.DateTimeField(null=True)
    end_time = models.DateTimeField(null=True)
    working_hours = models.FloatField(default=0.0, validators=[MinValueValidator(0)])
    # số công làm việc (với ngày thường 3 mức 0, 0.5, 1, với ngày khác: 0-1)
    work_number = models.FloatField(default=0.0, blank=False, null=False,
                                    validators=[MaxValueValidator(1.0), MinValueValidator(0.0)])
    # ngày công
    working_day = models.DateField()
    # forgot_attendance = models.BooleanField(default=False)
    # leave_without_reason = models.FloatField(default=0.0)
    # với ngày làm việc tăng ca, default all = 0
    # đi muộn?
    is_late_in = models.BooleanField(default=False)
    # số phút đi muộn
    minutes_late_in = models.IntegerField(default=0, validators=[MinValueValidator(0)])
    # về sớm
    is_early_out = models.BooleanField(default=False)
    # số phút về sớm
    minutes_early_out = models.IntegerField(default=0, validators=[MinValueValidator(0)])

    face_attendances = models.ManyToManyField(FaceAttendance, blank=True)
    tickets = models.ManyToManyField(Ticket, blank=True)

    #
    # # số công làm thêm (0-1) (tính theo số giờ /8 ) * hệ số OT ngày OT
    # overtime_work = models.FloatField(default=0.0, validators=[MinValueValidator(0), MaxValueValidator(1)])
    # số giờ làm thêm
    overtime_hour = models.FloatField(default=0.0, null=False, validators=[MinValueValidator(0)])

    class Meta:
        db_table = 'attendance'

    def __str__(self):
        return 'id: {}, user: {}, work_type: {}'.format(self.id, self.user, self.work_type)


class AttendanceStatistics(CommonModel):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    month = models.DateField()
    # công làm việc thực tế
    actual_work_number = models.FloatField(default=0.0)
    # công chuẩn trong tháng
    standard_work_number = models.FloatField(default=0)
    # số lần đi muộn
    times_late_in = models.IntegerField(default=0)
    # tổng số phút đi muộn
    minutes_late_in = models.IntegerField(default=0)
    # số lần vể sớm
    times_early_out = models.IntegerField(default=0)
    # tổng số phút về sớm
    minutes_early_out = models.IntegerField(default=0)
    # số công nghỉ không lý do
    off_without_reason = models.FloatField(default=0.0)
    # số lần quên check in/out
    forgot_check_in_out = models.IntegerField(default=0, blank=False, null=True)
    # số giờ làm thêm
    overtime_hour = models.FloatField(default=0.0, blank=False, null=False)
    # tiền phạt đến muộn
    # penalty_being_late = models.FloatField(default=0.0, blank=False, null=False)
    # # tiền phạt về sớm
    # early_return_penalty = models.FloatField(default=0.0, blank=False, null=False)
    # # tiền phạt nghỉ không lý do
    # penalty_leaving_without_reason = models.FloatField(default=0.0, blank=False, null=False)
    # # tiền phạt quên chấm công
    # penalty_forgetting_attendance = models.FloatField(default=0.0, blank=False, null=False)

    is_closed = models.BooleanField(default=False)
    ot_daily_work = models.FloatField(default=0.0)
    ot_day_off = models.FloatField(default=0.0)
    ot_holiday = models.FloatField(default=0.0)


    class Meta:
        db_table = 'attendance_statistics'
