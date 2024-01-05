import jwt
import datetime
from django.utils import timezone
from django.conf import settings
from rest_framework import exceptions
from rest_framework.authentication import BaseAuthentication, get_authorization_header
from rest_framework.response import Response
from rest_framework_jwt.utils import jwt_encode_handler

import apps.common.response_interface as rsp
from apps.authentication.models import Token
from apps.user.models import User
from apps.user.serializers import UserSerializer
from apps.user_work.models import UserWork
from apps.user_work.serializers.response_serializer import UserWorkSerializer


class CustomAuthentication(BaseAuthentication):
    authentication_header_prefix = 'JWT'

    def authenticate(self, request):
        auth = get_authorization_header(request).split()

        if not auth or auth[0].lower() != self.authentication_header_prefix.lower().encode():
            return None

        if len(auth) == 1:
            msg = 'Invalid token header. No credentials provided.'
            raise exceptions.AuthenticationFailed(msg)
        elif len(auth) > 2:
            msg = 'Invalid token header. Token string should not contain spaces.'
            raise exceptions.AuthenticationFailed(msg)

        try:
            token = auth[1].decode()
        except UnicodeError:
            msg = 'Invalid token header. Token string should not contain invalid characters.'
            raise exceptions.AuthenticationFailed(msg)

        return self.authenticate_credentials(token)

    def authenticate_credentials(self, token):
        try:
            payload = jwt.decode(token, settings.SECRET_KEY)
            print(payload)
        except jwt.ExpiredSignature:
            print('Signature has expired.')
            msg = 'Signature has expired.'
            raise exceptions.AuthenticationFailed(msg)
        except jwt.DecodeError:
            print('Error decoding signature.')
            msg = 'Error decoding signature.'
            raise exceptions.AuthenticationFailed(msg)
        except jwt.InvalidTokenError:
            print('invalid token')
            raise exceptions.AuthenticationFailed('invalid token')

        try:
            token = Token.objects.select_related('user').get(
                user_id=payload.get('user_id'), token=payload.get('time_create')
            )
        except Token.DoesNotExist:
            # # print('No found token')
            return None
            raise exceptions.AuthenticationFailed('No found token')

        return token.user, token

    def is_expired(token):
        return timezone.now() - token.created_at - settings.EXPIRING_TOKEN_DURATION > datetime.timedelta(seconds=0)


class JWTToken(object):
    def __init__(self, user, time_token, is_new_user=False):
        self.user = user
        self.token = time_token
        self.is_new_user = is_new_user

    def make_token(self, request, status):
        payload = {
            'user_id': self.user.id,
            'time_create': self.token,
        }
        token = jwt_encode_handler(payload)
        context = {'request': request, 'is_new_user': self.is_new_user}
        user_profile = User.object.filter(pk=self.user.id).first()
        user_work = UserWork.objects.filter(user=self.user, deleted_at__isnull=True).first()
        if user_work:
            work = UserWorkSerializer(user_work, context=context).data
        else:
            work = None

        profile = UserSerializer(user_profile, context=context)

        response_data = {
            'token': token,
            'profile': profile.data,
            'work': work
        }
        general_reponse = rsp.Response(response_data).generate_response()
        return Response(general_reponse, status=status)
