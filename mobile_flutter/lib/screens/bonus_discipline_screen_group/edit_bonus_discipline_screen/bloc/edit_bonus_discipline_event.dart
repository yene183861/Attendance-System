part of 'edit_bonus_discipline_bloc.dart';

abstract class EditBonusDisciplineEvent {}

class InitEvent extends EditBonusDisciplineEvent {
  InitEvent();
}

class GetEditBonusDisciplineEvent extends EditBonusDisciplineEvent {
  GetEditBonusDisciplineEvent();
}

class GetOrganizationEvent extends EditBonusDisciplineEvent {
  GetOrganizationEvent();
}

class ChangeOrganizationEvent extends EditBonusDisciplineEvent {
  final OrganizationModel model;
  ChangeOrganizationEvent({required this.model});
}

class GetBranchOfficeEvent extends EditBonusDisciplineEvent {
  GetBranchOfficeEvent();
}

class ChangeBranchOfficeEvent extends EditBonusDisciplineEvent {
  final BranchOfficeModel model;
  ChangeBranchOfficeEvent({required this.model});
}

class GetDepartmentEvent extends EditBonusDisciplineEvent {
  GetDepartmentEvent();
}

class ChangeDepartmentEvent extends EditBonusDisciplineEvent {
  final DepartmentModel model;
  ChangeDepartmentEvent({required this.model});
}

class ChangeTeamEvent extends EditBonusDisciplineEvent {
  final TeamModel model;
  ChangeTeamEvent({required this.model});
}

class GetTeamEvent extends EditBonusDisciplineEvent {
  GetTeamEvent();
}

class SearchUserEvent extends EditBonusDisciplineEvent {
  final String text;
  SearchUserEvent({required this.text});
}

class SelectUserEvent extends EditBonusDisciplineEvent {
  final UserWorkModel user;
  SelectUserEvent({required this.user});
}

class DeleteBonusEvent extends EditBonusDisciplineEvent {
  final int id;
  DeleteBonusEvent({required this.id});
}

class AddBonusEvent extends EditBonusDisciplineEvent {
  final RewardOrDisciplineModel model;
  AddBonusEvent({required this.model});
}

class UpdateBonusEvent extends EditBonusDisciplineEvent {
  final RewardOrDisciplineModel model;
  UpdateBonusEvent({required this.model});
}

class ChangeMonthEvent extends EditBonusDisciplineEvent {
  final DateTime month;
  ChangeMonthEvent({required this.month});
}

class ChangeUserList extends EditBonusDisciplineEvent {
  final List<UserWorkModel> users;
  ChangeUserList({required this.users});
}
