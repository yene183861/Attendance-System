part of 'ticket_reason_bloc.dart';

abstract class TicketReasonEvent {}

class InitEvent extends TicketReasonEvent {
  InitEvent();
}

class GetTicketReasonEvent extends TicketReasonEvent {
  GetTicketReasonEvent();
}

class ChangeTicketTypeEvent extends TicketReasonEvent {
  final TicketType ticketType;
  ChangeTicketTypeEvent({required this.ticketType});
}

class ChangeOrganizationEvent extends TicketReasonEvent {
  final OrganizationModel organizationModel;
  ChangeOrganizationEvent({required this.organizationModel});
}

class ChangeByTimeEvent extends TicketReasonEvent {
  final ByTime byTime;
  ChangeByTimeEvent({required this.byTime});
}

class IsApplyFilterTypeEvent extends TicketReasonEvent {
  final bool isApplyFilter;
  IsApplyFilterTypeEvent({required this.isApplyFilter});
}

class IsFilterByTimeEvent extends TicketReasonEvent {
  final bool isApplyFilter;
  IsFilterByTimeEvent({required this.isApplyFilter});
}

class DeleteTicketReasonEvent extends TicketReasonEvent {
  final int id;
  DeleteTicketReasonEvent({required this.id});
}
