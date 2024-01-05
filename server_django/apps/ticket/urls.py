from django.conf.urls import url
from django.urls import include
from rest_framework.routers import DefaultRouter
from apps.ticket.views import TicketView

router = DefaultRouter()
router.register('', TicketView)

urlpatterns = [
    url('ticket/', include(router.urls)),
]

