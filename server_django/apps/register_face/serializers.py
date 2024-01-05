from datetime import date

from rest_framework import serializers


from apps.user.serializers import UserCommonInfoSerializer

from apps.common.utils import *

from apps.register_face.models import RegisterFace
from apps.register_face.tasks.cronjob_train_model import handle_video_train_model_task


class RegisterFaceSerializer(serializers.ModelSerializer):
    user = UserCommonInfoSerializer()
    image = serializers.SerializerMethodField()

    class Meta:
        model = RegisterFace
        fields = ('id', 'user', 'image', 'created_at', 'updated_at')
        extra_kwargs = {
            'created_at': {'format': settings.DATE_TIME_FORMATS[0]},
            'updated_at': {'format': settings.DATE_TIME_FORMATS[0]},
        }

    def get_image(self, instance):
        image = get_random_image(instance.user.id)
        if not image:
            return None
        path = get_image_url_from_path(image)
        request = self.context.get('request')
        protocol = 'https' if request.is_secure() else 'http'
        host = request.get_host()
        t = f'{protocol}://{host}{path}'
        return t



class CreateRegisterFaceSerializer(serializers.ModelSerializer):
    class Meta:
        model = RegisterFace
        fields = ('user', 'video_file')

    def validate(self, attrs):
        print(attrs)
        print(attrs.get('video_file'))
        user_request = self.context.get('request').user
        user = attrs.get('user')
        if user_request.user_type > user.user_type:
            raise CustomException(ErrorCode.error_not_permisstion)
        check_user_under_management(user_request, user)
        return attrs

    def create(self, validated_data):
        user_id = validated_data.get('user').id
        face = super().create(validated_data)
        task_id = handle_video_train_model_task.delay(user_id, face.video_file.path)
        itask_id = task_id.id
        print('\n')
        print(f'task_id: {itask_id}')
        task_status = task_id.status
        print(task_status)
        print('\n')
        return face

# class UpdateRegisterFaceSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = RegisterFace
#         fields = ('video_file')
#
#     def update(self, instance, validated_data):
#         obj = self.context.get('view').get_object()
#






