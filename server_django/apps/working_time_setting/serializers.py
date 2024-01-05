from rest_framework import serializers
from django.conf import settings
from django.utils import timezone
from datetime import datetime, timedelta

from apps.common.constants import UserType

from apps.branch_office.models import BranchOffice
from apps.user_work.models import UserWork

from apps.user.serializers import UserCommonInfoSerializer
from apps.user_work.serializers.response_serializer import UserWorkSerializer
from apps.organization.serializers import OrganizationCommonSerializer
from apps.working_time_setting.models import WorkingTimeType, WorkingTimeSetting
from apps.common.exception import CustomException
from apps.common.error_code import Error, ErrorCode
from apps.common.utils import get_timedelta_between_days


class WorkingTimeTypeSerializer(serializers.ModelSerializer):
    organization = OrganizationCommonSerializer()

    class Meta:
        model = WorkingTimeType
        fields = ('id', 'organization', 'start_time', 'end_time', 'break_time', 'status', 'default')
        extra_kwargs = {
            'start_time': {'format': settings.TIME_FORMATS[0]},
            'end_time': {'format': settings.TIME_FORMATS[0]},
            'break_time': {'format': settings.TIME_FORMATS[0]},
        }


class CreateWorkingTimeTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = WorkingTimeType
        fields = ('organization', 'start_time', 'end_time', 'break_time', 'status', 'default')
        extra_kwargs = {
            'start_date': {'format': settings.DATE_FORMATS[0]},
            'end_date': {'format': settings.DATE_FORMATS[0]},
        }

    def validate(self, attrs):
        end_time = attrs.get('end_time', None)
        start_time = attrs.get('start_time', None)
        break_time = attrs.get('break_time', None)

        if start_time < break_time < end_time:
            time_difference = get_timedelta_between_days(start_time, end_time)
            if time_difference < timedelta(hours=9):
                raise CustomException(ErrorCode.error_json_parser,
                                      custom_message='Working time must be at least 8 hours')
            return attrs
        else:
            raise CustomException(ErrorCode.error_json_parser,
                                  custom_message='Time invalid')

    def create(self, validated_data):
        organization = validated_data.get('organization')
        start_time = validated_data.get('start_time')
        end_time = validated_data.get('end_time')
        break_time = validated_data.get('break_time')
        validated_data['status'] = True
        is_exist = WorkingTimeType.objects.filter(organization=organization, start_time=start_time, end_time=end_time,
                                                  break_time=break_time, deleted_at__isnull=True).first()
        if is_exist:
            raise CustomException(ErrorCode.error_json_parser,
                                  custom_message='Working time type has exist in the organization')
        else:
            set_default = validated_data.get('default', False)
            default = WorkingTimeType.objects.filter(organization=organization, default=True, deleted_at__isnull=True).first()
            if default:
                if set_default:
                    default.default = False
                    default.save()
            else:
                validated_data['default'] = True
            working_time_type = WorkingTimeType.objects.create(**validated_data)
            return working_time_type

    def update(self, instance, validated_data):
        validated_data.pop('organization')
        default = validated_data.get('default', None)
        status = validated_data.get('status', None)

        start_time = validated_data.get('start_time')
        end_time = validated_data.get('end_time')
        break_time = validated_data.get('break_time')
        is_exist = WorkingTimeType.objects.filter(organization=instance.organization, start_time=start_time,
                                                  end_time=end_time,
                                                  break_time=break_time, deleted_at__isnull=True).first()
        if is_exist.id != instance.id:
            raise CustomException(ErrorCode.error_json_parser,
                                  custom_message='Working time type has exist in the organization')
        else:
            if default is not None and default != instance.default:
                if default:
                    working_time_type = WorkingTimeType.objects.filter(organization=instance.organization,
                                                                       default=True, deleted_at__isnull=True).first()
                    if working_time_type:
                        working_time_type.default = False
                        working_time_type.save()

                else:
                    raise CustomException(ErrorCode.error_json_parser,
                                          custom_message='The organization should have a default working time frame')

            if status is not None and status != instance.status:
                default = default if default is not None else instance.default
                if default and not status:
                    raise CustomException(ErrorCode.error_json_parser,
                                          custom_message='The organization should have a default working time frame in active status')
            return super().update(instance, validated_data)


class WorkingTimeSettingSerializer(serializers.ModelSerializer):
    user = UserCommonInfoSerializer()

    class Meta:
        model = WorkingTimeSetting
        fields = ('id', 'user', 'start_date', 'end_date', 'setting_type', 'status')
        extra_kwargs = {
            'start_date': {'format': settings.DATE_FORMATS[0]},
            'end_date': {'format': settings.DATE_FORMATS[0]},
        }


class CreateWorkingTimeSettingSerializer(serializers.ModelSerializer):
    class Meta:
        model = WorkingTimeSetting
        fields = ('user', 'start_date', 'end_date', 'setting_type', 'status')
        extra_kwargs = {
            'start_date': {'format': settings.DATE_FORMATS[0]},
            'end_date': {'format': settings.DATE_FORMATS[0]},
        }

    def validate(self, attrs):
        start_date = attrs.get('start_date', None)
        end_date = attrs.get('end_date', None)
        if start_date > end_date:
            raise CustomException(ErrorCode.error_json_parser,
                                  custom_message='The end_date must be greater than the start_date')
        if (end_date - start_date).days < 60:
            raise CustomException(ErrorCode.error_json_parser,
                                  custom_message='The minimum time to apply this work schedule is 2 months')
        return attrs

    def create(self, validated_data):
        validated_data['status'] = True
        return super().create(validated_data)

    def update(self, instance, validated_data):
        validated_data.pop('user')
        end_date = validated_data.get('end_date', instance.end_date)
        start_date = validated_data.get('start_date', instance.start_date)
        setting_type = validated_data.get('setting_type', instance.setting_type)
        status = validated_data.get('status', instance.status)
        now = datetime.now().date()
        print(now)
        print('sdsdsd')
        print(now > instance.end_date)

        if now > instance.end_date:
            print('sfssf 12')
            raise CustomException(ErrorCode.error_client,
                                  custom_message='Can\'t to edit this user\'s working time settings in the past')
        else:
            if start_date < now < end_date:
                days = (now - start_date).days
                print(f'số ngày chênh lệch: {days}')
                print((end_date - start_date).days)
                if (end_date - start_date).days >= (60 + days):
                    if setting_type != instance.setting_type or status != instance.status:
                        # tách thành 2 record
                        validated_data['end_date'] = now
                        validated_data['setting_type'] = instance.setting_type
                        validated_data['status'] = False
                        t = super().update(instance, validated_data)

                        validated_data['start_date'] = now + timedelta(days=1)
                        validated_data['user'] = instance.user
                        validated_data['end_date'] = end_date
                        validated_data['setting_type'] = setting_type
                        print(validated_data)
                        m = WorkingTimeSetting.objects.filter(user=instance.user, start_date=start_date, end_date=end_date, deleted_at__isnull=True).first()
                        if m:
                            validated_data['status'] = status
                            t = super().update(m, validated_data)
                            return t
                        else:
                            t = super().create(validated_data)
                            # trường hợp chuyển trạng thái sang false nhưng đang diễn ra do tạo mới mặc định là true
                            t.status = status
                            t.save()
                            return t
                    else:
                        return super().update(instance, validated_data)
                else:
                    err = None if days == 0 else f'{days} days'
                    raise CustomException(ErrorCode.error_client,
                                          custom_message=f'The minimum time to apply this work schedule is least at 2 months {err} ')
            else:
                print('eeeeeeeee')
                if now == end_date:
                    raise CustomException(ErrorCode.error_client,
                                          custom_message=f'Today is the expiration date of this time framework, if you want to change it, please create a new working time setting.')
                elif now > end_date:
                    raise CustomException(ErrorCode.error_client,
                                          custom_message='Can\'t to edit this user\'s working time settings in the past')
                return super().update(instance, validated_data)
