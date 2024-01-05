from django.conf import settings
from django.core.mail import send_mail


def send_mail_user(recipient_list, message, subject):
    print('send mail')
    print(recipient_list)
    print(message)
    print(subject)
    print(settings.EMAIL_HOST_USER)

    send_mail(
        subject,
        message,
        from_email=settings.EMAIL_HOST_USER,
        recipient_list=recipient_list,
        fail_silently=False,
    )
