from django.conf.urls import url
from django.urls import include

urlpatterns = [
    url('', include('apps.branch_office.urls')),
    url('', include('apps.department.urls')),
    url('', include('apps.organization.urls')),
    url('', include('apps.team.urls')),
    url('', include('apps.working_time_setting.urls')),
    url('', include('apps.allowance.urls')),
    url('', include('apps.personnel_evaluation.urls')),
    url('', include('apps.contract.urls')),
    url('', include('apps.reward_and_discipline.urls')),
    url('', include('apps.ticket.urls')),
    url('', include('apps.ticket_type.urls')),
    url('', include('apps.search.urls')),

    # url('', include('apps.notification.urls')),
    url('', include('apps.register_face.urls')),
    url('', include('apps.salary.urls')),
    url('', include('apps.user.urls')),
    url('', include('apps.user_work.urls')),
    url('', include('apps.attendance.urls')),
    url('', include('apps.authentication.urls')),
]