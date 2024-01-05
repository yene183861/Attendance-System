part of 'detail_ticket_bloc.dart';

abstract class DetailTicketEvent {}

class InitEvent extends DetailTicketEvent {
  InitEvent();
}

class GetDetailTicketEvent extends DetailTicketEvent {
  GetDetailTicketEvent();
}

class GetUserWorkEvent extends DetailTicketEvent {
  GetUserWorkEvent();
}

class ChangeDataEvent extends DetailTicketEvent {
  ChangeDataEvent();
}

class DeleteDetailTicketEvent extends DetailTicketEvent {
  final int id;
  DeleteDetailTicketEvent({required this.id});
}
