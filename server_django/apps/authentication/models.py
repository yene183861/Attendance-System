from django.db import models
from apps.user.models import User
from apps.common.models import CommonModel


class Token(CommonModel):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='auth_token')
    token = models.CharField(max_length=255)

    class Meta:
        db_table = 'auth_token'

    def __str__(self):
        return "id:{}, userId:{}, token:{}, createAt:{}".format(self.id, self.user, self.token, self.created_at)