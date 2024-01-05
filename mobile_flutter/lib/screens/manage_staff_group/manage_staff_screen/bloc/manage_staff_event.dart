part of 'manage_staff_bloc.dart';

abstract class ManageStaffEvent {}

class GetUserEvent extends ManageStaffEvent {
  GetUserEvent();
}

class InitEvent extends ManageStaffEvent {
  InitEvent();
}

class GetOrganizationEvent extends ManageStaffEvent {
  GetOrganizationEvent();
}

class ChangeOrganizationEvent extends ManageStaffEvent {
  final OrganizationModel organizationModel;
  ChangeOrganizationEvent({required this.organizationModel});
}

class GetBranchOfficeEvent extends ManageStaffEvent {
  GetBranchOfficeEvent();
}

class ChangeBranchOfficeEvent extends ManageStaffEvent {
  final BranchOfficeModel? branchOfficeModel;
  ChangeBranchOfficeEvent({this.branchOfficeModel});
}

class GetDepartmentEvent extends ManageStaffEvent {
  GetDepartmentEvent();
}

class ChangeDepartmentEvent extends ManageStaffEvent {
  final DepartmentModel? departmentModel;
  ChangeDepartmentEvent({this.departmentModel});
}

class GetTeamEvent extends ManageStaffEvent {
  GetTeamEvent();
}

class ChangeTeamEvent extends ManageStaffEvent {
  final TeamModel? teamModel;
  ChangeTeamEvent({this.teamModel});
}

class DeleteUserEvent extends ManageStaffEvent {
  final UserModel user;
  DeleteUserEvent({required this.user});
}
