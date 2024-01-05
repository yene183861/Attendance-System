part of 'home_bloc.dart';

abstract class HomeEvent {}

class InitEvent extends HomeEvent {
  InitEvent();
}

class GetHomeEvent extends HomeEvent {
  GetHomeEvent();
}

class ChangeTicketTypeEvent extends HomeEvent {
  final TicketType ticketType;
  ChangeTicketTypeEvent({required this.ticketType});
}

class ChangeOrganizationEvent extends HomeEvent {
  final OrganizationModel organizationModel;
  ChangeOrganizationEvent({required this.organizationModel});
}

class ChangeByTimeEvent extends HomeEvent {
  final ByTime byTime;
  ChangeByTimeEvent({required this.byTime});
}

class IsApplyFilterTypeEvent extends HomeEvent {
  final bool isApplyFilter;
  IsApplyFilterTypeEvent({required this.isApplyFilter});
}

class IsFilterByTimeEvent extends HomeEvent {
  final bool isApplyFilter;
  IsFilterByTimeEvent({required this.isApplyFilter});
}

class DeleteHomeEvent extends HomeEvent {
  final int id;
  DeleteHomeEvent({required this.id});
}
