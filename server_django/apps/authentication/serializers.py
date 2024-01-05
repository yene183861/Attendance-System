from django.conf import settings
from django.contrib.auth import authenticate
from rest_framework import serializers

from apps.common.error_code import ErrorCode
from apps.common.exception import CustomException
from apps.common.serializers import TrimmedCharField
from apps.common.send_mail import send_mail_user

from apps.user.models import User


class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField(required=True, max_length=255)
    password = TrimmedCharField(required=True, max_length=255)

    def validate(self, attrs):
        email = attrs['email'].lower()
        user = authenticate(username=email, password=attrs['password'])
        if not user:
            raise CustomException(ErrorCode.email_or_password_invalid)
        return user


class ResetPasswordSerializer(serializers.Serializer):
    email = serializers.EmailField(max_length=255, required=True, allow_null=False, allow_blank=False)

    def validate(self, data):
        email = data.get('email', None)
        user = User.object.filter(email=email).first()
        if not user:
            raise CustomException(ErrorCode.account_not_exist)
        data['user'] = user
        return data

    def create(self, validated_data):
        user = validated_data.get('user')
        new_password = user.make_random_password()
        user.set_password(new_password)
        user.save()
        print('DONNNNEEEE 1')

        send_mail_user([user.email], subject='Reset password', message='Your new password is {}'.format(new_password))
        return validated_data
