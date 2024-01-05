part of 'new_user_bloc.dart';

abstract class NewUserEvent {}

class InitNewUserEvent extends NewUserEvent {
  final CreateUserArgument createUserArgument;
  InitNewUserEvent(this.createUserArgument);
}

class GetOrganizationEvent extends NewUserEvent {
  GetOrganizationEvent();
}

class ChangeOrganizationEvent extends NewUserEvent {
  final OrganizationModel organizationModel;
  ChangeOrganizationEvent({required this.organizationModel});
}

class GetBranchOfficeEvent extends NewUserEvent {
  GetBranchOfficeEvent();
}

class ChangeBranchOfficeEvent extends NewUserEvent {
  final BranchOfficeModel branchOfficeModel;
  ChangeBranchOfficeEvent({required this.branchOfficeModel});
}

class GetDepartmentEvent extends NewUserEvent {
  GetDepartmentEvent();
}

class ChangeDepartmentEvent extends NewUserEvent {
  final DepartmentModel departmentModel;
  ChangeDepartmentEvent({required this.departmentModel});
}

class GetTeamEvent extends NewUserEvent {
  GetTeamEvent();
}

class ChangeTeamEvent extends NewUserEvent {
  final TeamModel teamModel;
  ChangeTeamEvent({required this.teamModel});
}

class ChangeUserTypeEvent extends NewUserEvent {
  final UserType userType;

  ChangeUserTypeEvent({required this.userType});
}

class ChangeWorkStatusEvent extends NewUserEvent {
  final WorkStatus workStatus;

  ChangeWorkStatusEvent({required this.workStatus});
}

class CreateUserEvent extends NewUserEvent {
  final String? position;
  final String email;
  final String fullName;
  CreateUserEvent({this.position, required this.email, required this.fullName});
}

class CheckValidEmailEvent extends NewUserEvent {
  final bool isValid;
  CheckValidEmailEvent(this.isValid);
}
