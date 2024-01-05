from django.db import models
from apps.common.models import CommonModel
from apps.user.models import User


class RegisterFace(CommonModel):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='register_face')
    video_file = models.FileField(upload_to='videos/')


    class Meta:
        db_table = 'register_face'

    # def video_file(self):
    #     if self.video_file:
    #         return u'<'
