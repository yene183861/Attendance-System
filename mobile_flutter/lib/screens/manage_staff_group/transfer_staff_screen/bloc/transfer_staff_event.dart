part of 'transfer_staff_bloc.dart';

abstract class TransferStaffEvent {}

class InitTransferStaffEvent extends TransferStaffEvent {
  InitTransferStaffEvent();
}

class GetOrganizationEvent extends TransferStaffEvent {
  GetOrganizationEvent();
}

class ChangeOrganizationEvent extends TransferStaffEvent {
  final OrganizationModel organizationModel;
  ChangeOrganizationEvent({required this.organizationModel});
}

class GetBranchOfficeEvent extends TransferStaffEvent {
  GetBranchOfficeEvent();
}

class ChangeBranchOfficeEvent extends TransferStaffEvent {
  final BranchOfficeModel branchOfficeModel;
  ChangeBranchOfficeEvent({required this.branchOfficeModel});
}

class GetDepartmentEvent extends TransferStaffEvent {
  GetDepartmentEvent();
}

class ChangeDepartmentEvent extends TransferStaffEvent {
  final DepartmentModel departmentModel;
  ChangeDepartmentEvent({required this.departmentModel});
}

class GetTeamEvent extends TransferStaffEvent {
  GetTeamEvent();
}

class ChangeTeamEvent extends TransferStaffEvent {
  final TeamModel teamModel;
  ChangeTeamEvent({required this.teamModel});
}

class ChangeUserTypeEvent extends TransferStaffEvent {
  final UserType userType;

  ChangeUserTypeEvent({required this.userType});
}

class ChangeWorkStatusEvent extends TransferStaffEvent {
  final WorkStatus workStatus;

  ChangeWorkStatusEvent({required this.workStatus});
}

class TransferUserWorkEvent extends TransferStaffEvent {
  final String? position;
  TransferUserWorkEvent({this.position});
}
