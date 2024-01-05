part of 'edit_ticket_reason_bloc.dart';

abstract class EditTicketReasonEvent {}

class InitEvent extends EditTicketReasonEvent {
  InitEvent();
}

class ChangeTicketTypeEvent extends EditTicketReasonEvent {
  final TicketType ticketType;
  ChangeTicketTypeEvent({required this.ticketType});
}

class ChangeByTimeEvent extends EditTicketReasonEvent {
  final ByTime byTime;
  ChangeByTimeEvent({required this.byTime});
}

class ChangeOrganizationEvent extends EditTicketReasonEvent {
  final OrganizationModel organizationModel;
  ChangeOrganizationEvent({required this.organizationModel});
}

class GetOrganizationEvent extends EditTicketReasonEvent {
  GetOrganizationEvent();
}

class CreateTicketReasonEvent extends EditTicketReasonEvent {
  final TicketReasonModel ticketReasonModel;
  CreateTicketReasonEvent({required this.ticketReasonModel});
}

class UpdateTicketReasonEvent extends EditTicketReasonEvent {
  final TicketReasonModel ticketReasonModel;
  final int id;
  UpdateTicketReasonEvent({required this.ticketReasonModel, required this.id});
}

class ChangeStatusCaculWork extends EditTicketReasonEvent {
  final bool isCacul;
  ChangeStatusCaculWork(this.isCacul);
}
