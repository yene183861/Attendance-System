part of 'contract_bloc.dart';

abstract class ContractEvent {}

class InitEvent extends ContractEvent {
  InitEvent();
}

class GetContractEvent extends ContractEvent {
  GetContractEvent();
}

class UpdateContractEvent extends ContractEvent {
  final ContractModel model;
  final int id;
  UpdateContractEvent({required this.model, required this.id});
}

class DeleteContractEvent extends ContractEvent {
  final int id;
  DeleteContractEvent({required this.id});
}

class SubmitContractEvent extends ContractEvent {
  final LoginParams loginParams;
  SubmitContractEvent({required this.loginParams});
}

class SearchUserWorkEvent extends ContractEvent {
  final String name;
  SearchUserWorkEvent({required this.name});
}

class SelectUserEvent extends ContractEvent {
  final UserWorkModel user;
  SelectUserEvent({required this.user});
}

class GetOrganizationEvent extends ContractEvent {
  GetOrganizationEvent();
}

class ChangeOrganizationEvent extends ContractEvent {
  final OrganizationModel model;
  ChangeOrganizationEvent({required this.model});
}

class GetBranchOfficeEvent extends ContractEvent {
  GetBranchOfficeEvent();
}

class ChangeBranchOfficeEvent extends ContractEvent {
  final BranchOfficeModel model;
  ChangeBranchOfficeEvent({required this.model});
}

class GetDepartmentEvent extends ContractEvent {
  GetDepartmentEvent();
}

class ChangeDepartmentEvent extends ContractEvent {
  final DepartmentModel model;
  ChangeDepartmentEvent({required this.model});
}

class ChangeTeamEvent extends ContractEvent {
  final TeamModel model;
  ChangeTeamEvent({required this.model});
}

class GetTeamEvent extends ContractEvent {
  GetTeamEvent();
}

class CopyStateEvent extends ContractEvent {
  final CommonArgument arg;
  CopyStateEvent({required this.arg});
}

class FilterByDateEvent extends ContractEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  FilterByDateEvent({this.startDate, this.endDate});
}
