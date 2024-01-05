part of 'manage_ticket_bloc.dart';

abstract class ManageTicketEvent {}

class InitEvent extends ManageTicketEvent {
  InitEvent();
}

class GetManageTicketEvent extends ManageTicketEvent {
  GetManageTicketEvent();
}

class ChangeTicketTypeEvent extends ManageTicketEvent {
  final TicketType ticketType;
  ChangeTicketTypeEvent({required this.ticketType});
}

class ChangeOrganizationEvent extends ManageTicketEvent {
  final OrganizationModel organizationModel;
  ChangeOrganizationEvent({required this.organizationModel});
}

class ChangeByTimeEvent extends ManageTicketEvent {
  final ByTime byTime;
  ChangeByTimeEvent({required this.byTime});
}

class IsApplyFilterTypeEvent extends ManageTicketEvent {
  final bool isApplyFilter;
  IsApplyFilterTypeEvent({required this.isApplyFilter});
}

class IsFilterByTimeEvent extends ManageTicketEvent {
  final bool isApplyFilter;
  IsFilterByTimeEvent({required this.isApplyFilter});
}

class DeleteManageTicketEvent extends ManageTicketEvent {
  final int id;
  DeleteManageTicketEvent({required this.id});
}
