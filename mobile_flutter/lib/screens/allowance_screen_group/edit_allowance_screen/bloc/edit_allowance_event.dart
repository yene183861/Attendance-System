part of 'edit_allowance_bloc.dart';

abstract class EditAllowanceEvent {}

class CreateAllowanceEvent extends EditAllowanceEvent {
  final AllowanceModel allowanceModel;

  CreateAllowanceEvent({required this.allowanceModel});
}

class UpdateAllowanceEvent extends EditAllowanceEvent {
  final AllowanceModel allowanceModel;

  UpdateAllowanceEvent({required this.allowanceModel});
}

class DeleteAllowanceEvent extends EditAllowanceEvent {
  final int id;

  DeleteAllowanceEvent({required this.id});
}

class SelectByTimeEvent extends EditAllowanceEvent {
  final ByTime byTime;

  SelectByTimeEvent({required this.byTime});
}
