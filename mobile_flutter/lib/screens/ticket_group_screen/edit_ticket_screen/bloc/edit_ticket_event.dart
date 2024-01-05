part of 'edit_ticket_bloc.dart';

abstract class EditTicketEvent {}

class InitEvent extends EditTicketEvent {
  InitEvent();
}

class GetTicketReasonEvent extends EditTicketEvent {
  GetTicketReasonEvent();
}

class ChangeTicketTypeEvent extends EditTicketEvent {
  final TicketType ticketType;
  ChangeTicketTypeEvent({required this.ticketType});
}

class ChangeTicketReasonEvent extends EditTicketEvent {
  final TicketReasonModel tickerReason;
  ChangeTicketReasonEvent({required this.tickerReason});
}

class ChangeStartDateEvent extends EditTicketEvent {
  final DateTime startDate;
  ChangeStartDateEvent({required this.startDate});
}

class ChangeEndDateEvent extends EditTicketEvent {
  final DateTime endDate;
  ChangeEndDateEvent({required this.endDate});
}

class ChangeStartTimeEvent extends EditTicketEvent {
  final String startTime;
  ChangeStartTimeEvent({required this.startTime});
}

class ChangeEndTimeEvent extends EditTicketEvent {
  final String endTime;
  ChangeEndTimeEvent({required this.endTime});
}

class CreateTicketEvent extends EditTicketEvent {
  final String? description;

  CreateTicketEvent({
    this.description,
  });
}

class UpdateTicketEvent extends EditTicketEvent {
  final String? description;
  UpdateTicketEvent(
    this.description,
  );
}

class ChangeTicketStatusEvent extends EditTicketEvent {
  final TicketStatus ticketStatus;
  ChangeTicketStatusEvent({required this.ticketStatus});
}

class SearchUserEvent extends EditTicketEvent {
  final String text;
  SearchUserEvent({required this.text});
}

class SelectUserEvent extends EditTicketEvent {
  final UserWorkModel userWorkModel;
  SelectUserEvent({required this.userWorkModel});
}
