import datetime
import glob
import random
from django.conf import settings
from rest_framework import serializers

from apps.common.error_code import ErrorCode
from apps.common.exception import CustomException
from apps.common.constants import *
from apps.common.send_mail import send_mail_user
from apps.common.utils import get_image_url_from_path

from apps.user.models import User
from apps.common.constants import UserType

from apps.common.serializers import TrimmedCharField
from apps.user_work.serializers.request_serializer import CreateUserWorkSerializer


class UserSerializer(serializers.ModelSerializer):
    avatar_thumb = serializers.ImageField(read_only=True)

    class Meta:
        model = User
        fields = (
            'id', 'email', 'username', 'full_name', 'gender', 'user_type', 'birthday', 'phone_number',
            'address', 'avatar', 'avatar_thumb', 'is_active', 'created_at')
        extra_kwargs = {
            'created_at': {'format': settings.DATE_TIME_FORMATS[0]},
            'birthday': {'format': settings.DATE_FORMATS[0]}
        }


class UserCommonInfoSerializer(serializers.ModelSerializer):
    # avatar_thumb = serializers.ImageField(read_only=True)
    avatar_thumb= serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ('id', 'email', 'username', 'full_name', 'avatar', 'avatar_thumb', 'user_type', 'is_active')

    def get_avatar_thumb(self, instance):
        return instance.avatar_thumb.path

class CreateUserSerializer(serializers.ModelSerializer):
    user_work = CreateUserWorkSerializer(required=False, allow_null=True)

    class Meta:
        model = User
        fields = ('email', 'full_name', 'gender', 'user_type', 'user_work')

    def validate(self, attrs):
        return attrs
        # print(attrs)
        # user_type = attrs.get('user_type', None)
        # print('ssfsfsf')
        # print(user_type)
        # if user_type:
        #     return attrs
        # else:
        #     raise CustomException(ErrorCode.error_json_parser, custom_message='user_type is required')

    def create(self, validated_data):
        email = validated_data.get('email')
        user = User(
            email=email,
            full_name=validated_data.get('full_name'),
            gender=validated_data.get('gender', 0),
            user_type=validated_data.get('user_type')
        )
        avatar_default = random.choice(AvatarDefault.avatar_default)
        user.avatar = avatar_default
        password = user.make_random_password()
        send_mail_user(
            recipient_list=[email],
            message='Mật khẩu đăng nhập tài khoản office app của bạn là: {}'.format(password),
            subject='Tạo tài khoản office app')
        user.set_password(password)
        user.save()
        return user


class UpdateProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('username', 'birthday', 'phone_number', 'address', 'avatar', 'gender')
        extra_kwargs = {
            'avatar': {'required': False}
        }

    def create(self, validated_data):
        user = self.context.get('request').user
        user.avatar = validated_data.get('avatar', user.avatar)
        user.username = validated_data.get('username', user.username)
        user.birthday = validated_data.get('birthday', user.birthday)
        user.phone_number = validated_data.get('phone_number', user.phone_number)
        user.gender = validated_data.get('gender', user.gender)
        user.address = validated_data.get('address', user.address)
        return user


class ChangePasswordSerializer(serializers.Serializer):
    old_password = TrimmedCharField(max_length=255, required=True, allow_null=False, allow_blank=False)
    new_password = TrimmedCharField(max_length=255, required=True, allow_null=False, allow_blank=False)
    confirm_password = TrimmedCharField(max_length=255, required=True, allow_null=False, allow_blank=False)

    def validate(self, attrs):
        old_password = attrs.get('old_password', None)
        new_password = attrs.get('new_password', None)
        confirm_password = attrs.get('confirm_password', None)
        request = self.context['request']
        user = User.object.get(id=request.user.id)
        if not user.check_password(old_password):
            raise CustomException(ErrorCode.error_current_password_incorrect)
        if new_password != confirm_password:
            raise CustomException(ErrorCode.error_password_not_match)
        if not user.check_len_password(password=new_password):
            raise CustomException(ErrorCode.error_short_password)
        return attrs

    def create(self, validated_data):
        new_password = validated_data.get('new_password', None)

        user = self.context.get('request').user
        user.set_password(new_password)
        user.save()
        return validated_data
