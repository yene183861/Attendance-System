from django.contrib import admin
from apps.ticket.models import Ticket, DateTimeTicket

# Register your models here.
admin.site.register(DateTimeTicket)
admin.site.register(Ticket)

