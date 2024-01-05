part of 'ticket_bloc.dart';

abstract class TicketEvent {}

class InitEvent extends TicketEvent {
  InitEvent();
}

class GetTicketEvent extends TicketEvent {
  GetTicketEvent();
}

class SearchUserWorkEvent extends TicketEvent {
  final String name;
  SearchUserWorkEvent({required this.name});
}

class SelectUserEvent extends TicketEvent {
  final UserWorkModel user;
  SelectUserEvent({required this.user});
}

class ChangeTicketTypeEvent extends TicketEvent {
  final TicketType ticketType;
  ChangeTicketTypeEvent({required this.ticketType});
}

class DeleteTicketEvent extends TicketEvent {
  final int id;
  DeleteTicketEvent({required this.id});
}

class GetOrganizationEvent extends TicketEvent {
  GetOrganizationEvent();
}

class ChangeOrganizationEvent extends TicketEvent {
  final OrganizationModel model;
  ChangeOrganizationEvent({required this.model});
}

class GetBranchOfficeEvent extends TicketEvent {
  GetBranchOfficeEvent();
}

class ChangeBranchOfficeEvent extends TicketEvent {
  final BranchOfficeModel model;
  ChangeBranchOfficeEvent({required this.model});
}

class GetDepartmentEvent extends TicketEvent {
  GetDepartmentEvent();
}

class ChangeDepartmentEvent extends TicketEvent {
  final DepartmentModel model;
  ChangeDepartmentEvent({required this.model});
}

class ChangeTeamEvent extends TicketEvent {
  final TeamModel model;
  ChangeTeamEvent({required this.model});
}

class GetTeamEvent extends TicketEvent {
  GetTeamEvent();
}

class CopyStateEvent extends TicketEvent {
  final CommonArgument arg;
  CopyStateEvent({required this.arg});
}

class FilterYourTicket extends TicketEvent {
  final bool isYourTicket;
  FilterYourTicket({required this.isYourTicket});
}

class IsApplyFilterTypeEvent extends TicketEvent {
  final bool isApply;
  IsApplyFilterTypeEvent({required this.isApply});
}

class IsApplyFilterTicketStatusEvent extends TicketEvent {
  final bool isApply;
  IsApplyFilterTicketStatusEvent({required this.isApply});
}

class ChangeTicketStatusEvent extends TicketEvent {
  final TicketStatus status;
  ChangeTicketStatusEvent({required this.status});
}

class ChangeMonthEvent extends TicketEvent {
  final DateTime month;
  ChangeMonthEvent({required this.month});
}

class HandleTicketEvent extends TicketEvent {
  final TicketStatus status;
  final String? reason;
  final TicketModel ticket;
  HandleTicketEvent({
    required this.status,
    required this.ticket,
    this.reason,
  });
}
