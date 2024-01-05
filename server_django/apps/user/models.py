import random
from django.db import models
from django.contrib.auth.base_user import BaseUserManager, AbstractBaseUser
from django.contrib.auth.models import PermissionsMixin
from imagekit.models import ImageSpecField
from pilkit.processors import ResizeToFill

from apps.common.models import CommonModel, TrimmedCharFieldModel
from apps.common.constants import UserType, GenderType


class UserManager(BaseUserManager):
    def create_user(self, email, password, **extra_fields):
        if not email:
            raise ValueError('You have not provided a valid email address')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password, **extra_fields):
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_active', True)
        extra_fields.setdefault('user_type', 0)

        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')
        if extra_fields.get('user_type') != UserType.ADMIN.value:
            raise ValueError('Superuser must have user_type=0.')
        return self.create_user(email, password, **extra_fields)


class User(AbstractBaseUser, CommonModel, PermissionsMixin):
    email = models.EmailField(max_length=255, unique=True)
    username = TrimmedCharFieldModel(max_length=64, blank=True, null=True)
    password = models.CharField(max_length=255, blank=False, null=False)
    full_name = TrimmedCharFieldModel(max_length=255, blank=False, null=False)
    user_type = models.IntegerField(choices=UserType.choices(), default=UserType.STAFF.value)
    gender = models.IntegerField(choices=GenderType.choices(), default=GenderType.MALE.value)

    birthday = models.DateField(null=True)
    phone_number = TrimmedCharFieldModel(max_length=11, null=True)
    address = TrimmedCharFieldModel(max_length=255, null=True)
    avatar = models.ImageField(upload_to='avatars')
    avatar_thumb = ImageSpecField(source='avatar',
                                  processors=[ResizeToFill(256, 256)],
                                  format='JPEG',
                                  options={'quality': 100})
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=True)
    USERNAME_FIELD = 'email'
    # specify which fields are required when creating a superuser
    #  in addition to the default username and password fields
    REQUIRED_FIELDS = ['full_name', 'user_type']

    object = UserManager()

    class Meta:
        db_table = 'user'

    def has_perm(self, perm, obj=None):
        # does user have a specific permission
        return True

    def has_module_perms(self, app_label):
        # does user have permissions to view the app 'app_label'
        return True

    def make_random_password(self, length=8,
                             allowed_chars="abcdefghijklmnopqrstuvwxyz01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*"):
        return "".join(random.sample(allowed_chars, length))

    def check_len_password(self, password, length=8):
        return len(password) >= length

