part of 'edit_contract_bloc.dart';

abstract class EditContractEvent {}

class SearchUserEvent extends EditContractEvent {
  final String text;
  SearchUserEvent({required this.text});
}

class SelectUserEvent extends EditContractEvent {
  final UserWorkModel user;
  SelectUserEvent({required this.user});
}

class DeleteContractEvent extends EditContractEvent {
  final int id;
  DeleteContractEvent({required this.id});
}

class AddContractEvent extends EditContractEvent {
  final ContractModel model;
  AddContractEvent({required this.model});
}

class UpdateContractEvent extends EditContractEvent {
  final ContractModel model;
  UpdateContractEvent({required this.model});
}

class ChangeUserList extends EditContractEvent {
  final List<UserWorkModel> users;
  ChangeUserList({required this.users});
}

class ChangeStartDateEvent extends EditContractEvent {
  final DateTime startDate;
  ChangeStartDateEvent({required this.startDate});
}

class ChangeEndDateEvent extends EditContractEvent {
  final DateTime endDate;
  ChangeEndDateEvent({required this.endDate});
}

class ChangeSignDateEvent extends EditContractEvent {
  final DateTime signDate;
  ChangeSignDateEvent({required this.signDate});
}

class ChangeContractTypeEvent extends EditContractEvent {
  final ContractType contractType;
  ChangeContractTypeEvent({required this.contractType});
}
