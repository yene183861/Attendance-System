part of 'manage_staff_bloc.dart';

class ManageStaffState extends Equatable {
  final FormzStatus status;
  final String? message;
  final List<UserWorkModel>? users;
  final List<OrganizationModel>? organizationsList;
  final List<BranchOfficeModel>? branchesList;
  final List<DepartmentModel>? departmentsList;
  final List<TeamModel>? teamsList;
  final OrganizationModel? selectedOrganization;
  final BranchOfficeModel? selectedBranch;
  final DepartmentModel? selectedDepartment;
  final TeamModel? selectedTeam;

  const ManageStaffState({
    required this.status,
    this.message,
    this.users,
    this.organizationsList,
    this.branchesList,
    this.departmentsList,
    this.teamsList,
    this.selectedOrganization,
    this.selectedBranch,
    this.selectedDepartment,
    this.selectedTeam,
  });

  ManageStaffState copyWith({
    FormzStatus? status,
    String? message,
    List<UserWorkModel>? users,
    List<OrganizationModel>? organizationsList,
    List<BranchOfficeModel>? branchesList,
    List<DepartmentModel>? departmentsList,
    List<TeamModel>? teamsList,
    OrganizationModel? selectedOrganization,
    BranchOfficeModel? selectedBranch,
    DepartmentModel? selectedDepartment,
    TeamModel? selectedTeam,
  }) {
    return ManageStaffState(
      status: status ?? this.status,
      message: message ?? this.message,
      users: users ?? this.users,
      organizationsList: organizationsList ?? this.organizationsList,
      branchesList: branchesList ?? this.branchesList,
      departmentsList: departmentsList ?? this.departmentsList,
      teamsList: teamsList ?? this.teamsList,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      selectedTeam: selectedTeam ?? this.selectedTeam,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        users,
        organizationsList,
        branchesList,
        departmentsList,
        teamsList,
        selectedOrganization,
        selectedBranch,
        selectedDepartment,
        selectedTeam,
      ];
}
