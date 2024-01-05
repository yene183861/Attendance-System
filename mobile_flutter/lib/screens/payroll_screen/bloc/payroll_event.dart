part of 'payroll_bloc.dart';

abstract class PayrollEvent {}

class InitEvent extends PayrollEvent {
  InitEvent();
}

class GetPayrollEvent extends PayrollEvent {
  GetPayrollEvent();
}

class GetOrganizationEvent extends PayrollEvent {
  GetOrganizationEvent();
}

class ChangeOrganizationEvent extends PayrollEvent {
  final OrganizationModel model;
  ChangeOrganizationEvent({required this.model});
}

class GetBranchOfficeEvent extends PayrollEvent {
  GetBranchOfficeEvent();
}

class ChangeBranchOfficeEvent extends PayrollEvent {
  final BranchOfficeModel model;
  ChangeBranchOfficeEvent({required this.model});
}

class GetDepartmentEvent extends PayrollEvent {
  GetDepartmentEvent();
}

class ChangeDepartmentEvent extends PayrollEvent {
  final DepartmentModel model;
  ChangeDepartmentEvent({required this.model});
}

class ChangeTeamEvent extends PayrollEvent {
  final TeamModel model;
  ChangeTeamEvent({required this.model});
}

class GetTeamEvent extends PayrollEvent {
  GetTeamEvent();
}

class SearchUserEvent extends PayrollEvent {
  final String text;
  SearchUserEvent({required this.text});
}

class SelectUserEvent extends PayrollEvent {
  final UserWorkModel user;
  SelectUserEvent({required this.user});
}

// class DeleteBonusEvent extends PayrollEvent {
//   final int id;
//   DeleteBonusEvent({required this.id});
// }

class FilterByMonthEvent extends PayrollEvent {
  final DateTime month;
  FilterByMonthEvent({required this.month});
}

class UpdatePayrollEvent extends PayrollEvent {
  UpdatePayrollEvent();
}

class CreatePayrollEvent extends PayrollEvent {
  CreatePayrollEvent();
}
