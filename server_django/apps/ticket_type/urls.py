from django.conf.urls import url
from django.urls import include
from rest_framework.routers import DefaultRouter
from apps.ticket_type.views import TicketReasonView

router = DefaultRouter()
# router.register('time-shift', TimeShiftView)
# router.register('ticket-type', TicketTypeView)
router.register('ticket-reason', TicketReasonView)

urlpatterns = [
    url('', include(router.urls)),
]

