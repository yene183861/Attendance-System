part of 'transfer_staff_bloc.dart';

class TransferStaffState extends Equatable {
  final FormzStatus status;
  final String? message;
  final List<OrganizationModel>? organizationsList;
  final List<BranchOfficeModel>? branchsList;
  final List<DepartmentModel>? departmentsList;
  final List<TeamModel>? teamsList;
  final OrganizationModel? selectedOrganization;
  final BranchOfficeModel? selectedBranch;
  final DepartmentModel? selectedDepartment;
  final TeamModel? selectedTeam;
  final UserType? userType;
  final WorkStatus? workStatus;
  final UserWorkModel userWorkModel;

  const TransferStaffState({
    this.status = FormzStatus.pure,
    this.message,
    this.organizationsList,
    this.branchsList,
    this.departmentsList,
    this.teamsList,
    this.selectedOrganization,
    this.selectedBranch,
    this.selectedDepartment,
    this.selectedTeam,
    this.userType = UserType.STAFF,
    this.workStatus = WorkStatus.WORKING,
    required this.userWorkModel,
  });

  TransferStaffState copyWith({
    FormzStatus? status,
    String? message,
    List<OrganizationModel>? organizationsList,
    List<BranchOfficeModel>? branchsList,
    List<DepartmentModel>? departmentsList,
    List<TeamModel>? teamsList,
    OrganizationModel? selectedOrganization,
    BranchOfficeModel? selectedBranch,
    DepartmentModel? selectedDepartment,
    TeamModel? selectedTeam,
    UserType? userType,
    WorkStatus? workStatus,
    UserWorkModel? userWorkModel,
  }) {
    return TransferStaffState(
      status: status ?? this.status,
      message: message ?? this.message,
      organizationsList: organizationsList ?? this.organizationsList,
      branchsList: branchsList ?? this.branchsList,
      departmentsList: departmentsList ?? this.departmentsList,
      teamsList: teamsList ?? this.teamsList,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      selectedTeam: selectedTeam ?? this.selectedTeam,
      userType: userType ?? this.userType,
      workStatus: workStatus ?? this.workStatus,
      userWorkModel: userWorkModel ?? this.userWorkModel,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        organizationsList,
        branchsList,
        departmentsList,
        teamsList,
        selectedOrganization,
        selectedBranch,
        selectedDepartment,
        selectedTeam,
        userType,
        workStatus,
        userWorkModel,
      ];
}
