# from django.db import models
# from apps.utils.constants import DeviceType,NotificationStatus
# from apps.authentication.models import User
# from apps.organization.models import Organization

# # Create your models here.

# DEVICE_TYPE = (
#     (DeviceType.ANDROID.value, 'android'),
#     (DeviceType.IOS.value, 'ios'),
#     (DeviceType.WEB.value, 'web'),
# )  
# NOTIFICATION_STATUS = (
#     (NotificationStatus.UNREAD.value, 'unread'),
#     (NotificationStatus.READ.value, 'read'),
#     (NotificationStatus.MAKE_AS_UNREAD.value, 'mark_as_unread'),
# )  

# class FCMDevice(models.Model):
#     user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='fcm_device', default=None)
#     name = models.CharField(max_length=255, blank = True, null = True)
#     registration_id = models.CharField(max_length=255, blank=False, null = False)
#     device_id = models.CharField(max_length=150, blank = False, null = False)
#     is_active = models.BooleanField(default= True, blank = False, null = False)
#     device_type = models.IntegerField(choices=DEVICE_TYPE, blank=False, null = False)
#     date_created = models.DateTimeField(auto_now_add=True)
#     updated_at = models.DateTimeField(auto_now=True)
#     deleted_at = models.DateTimeField(default= None, blank = True, null = True)

#     class Meta:
#         db_table = 'fcm_device'
#         unique_together = ('registration_id', 'device_id')

# class NotificationType(models.Model):
#     '''
#     Thông báo hệ thống, thông báo đơn từ, thông báo chấm công...
#     '''
#     organization = models.ForeignKey(Organization, on_delete=models.SET_NULL, null=True, related_name='notification_type')
#     name = models.CharField(max_length=255)
#     created_at = models.DateTimeField(auto_now_add=True)
#     updated_at = models.DateTimeField(auto_now=True)
#     deleted_at = models.DateTimeField(default= None, blank = True, null = True)

#     class Meta:
#         db_table = 'notification_type'
#         unique_together = ('organization', 'name')


# class Notification(models.Model):
#     receiver = models.ForeignKey(User, on_delete=models.CASCADE, related_name='notification')
#     title = models.CharField(max_length=255, blank=False, null = False)
#     content = models.CharField(max_length=255, blank = True, null = True)
#     isSeen = models.BooleanField(default=False)
#     isRead = models.BooleanField(default=False)
#     notification_type = models.ForeignKey(NotificationType, on_delete=models.CASCADE, related_name='notification')
#     notification_status = models.IntegerField(NOTIFICATION_STATUS,default=NotificationStatus.UNREAD.value)
#     created_at = models.DateTimeField(auto_now_add=True)
#     updated_at = models.DateTimeField(auto_now=True)
#     deleted_at = models.DateTimeField(default= None, blank = True, null = True)

#     class Meta:
#         db_table = 'notification'