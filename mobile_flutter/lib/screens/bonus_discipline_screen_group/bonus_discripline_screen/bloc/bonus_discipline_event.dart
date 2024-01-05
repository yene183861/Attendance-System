part of 'bonus_discipline_bloc.dart';

abstract class BonusDisciplineEvent {}

class InitEvent extends BonusDisciplineEvent {
  InitEvent();
}

class GetBonusDisciplineEvent extends BonusDisciplineEvent {
  GetBonusDisciplineEvent();
}

class GetOrganizationEvent extends BonusDisciplineEvent {
  GetOrganizationEvent();
}

class ChangeOrganizationEvent extends BonusDisciplineEvent {
  final OrganizationModel model;
  ChangeOrganizationEvent({required this.model});
}

class GetBranchOfficeEvent extends BonusDisciplineEvent {
  GetBranchOfficeEvent();
}

class ChangeBranchOfficeEvent extends BonusDisciplineEvent {
  final BranchOfficeModel model;
  ChangeBranchOfficeEvent({required this.model});
}

class GetDepartmentEvent extends BonusDisciplineEvent {
  GetDepartmentEvent();
}

class ChangeDepartmentEvent extends BonusDisciplineEvent {
  final DepartmentModel model;
  ChangeDepartmentEvent({required this.model});
}

class ChangeTeamEvent extends BonusDisciplineEvent {
  final TeamModel model;
  ChangeTeamEvent({required this.model});
}

class GetTeamEvent extends BonusDisciplineEvent {
  GetTeamEvent();
}

class SearchUserEvent extends BonusDisciplineEvent {
  final String text;
  SearchUserEvent({required this.text});
}

class SelectUserEvent extends BonusDisciplineEvent {
  final UserWorkModel user;
  SelectUserEvent({required this.user});
}

class DeleteBonusEvent extends BonusDisciplineEvent {
  final int id;
  DeleteBonusEvent({required this.id});
}

class FilterByMonthEvent extends BonusDisciplineEvent {
  final DateTime month;
  FilterByMonthEvent({required this.month});
}

class ChangeTabEvent extends BonusDisciplineEvent {
  final bool isReward;
  ChangeTabEvent({required this.isReward});
}

class CopyStateEvent extends BonusDisciplineEvent {
  final CommonArgument arg;
  CopyStateEvent({required this.arg});
}
