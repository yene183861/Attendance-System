part of 'new_user_bloc.dart';

class NewUserState extends Equatable {
  final FormzStatus status;
  final String? message;
  final List<OrganizationModel>? organizationsList;
  final List<BranchOfficeModel>? branchesList;
  final List<DepartmentModel>? departmentsList;
  final List<TeamModel>? teamsList;
  final OrganizationModel? selectedOrganization;
  final BranchOfficeModel? selectedBranch;
  final DepartmentModel? selectedDepartment;
  final TeamModel? selectedTeam;
  final UserType? userType;
  final WorkStatus? workStatus;
  final bool? isValidEmail;

  const NewUserState({
    this.status = FormzStatus.pure,
    this.message,
    this.organizationsList,
    this.branchesList,
    this.departmentsList,
    this.teamsList,
    this.selectedOrganization,
    this.selectedBranch,
    this.selectedDepartment,
    this.selectedTeam,
    this.userType = UserType.STAFF,
    this.workStatus = WorkStatus.WORKING,
    this.isValidEmail,
  });

  NewUserState copyWith({
    FormzStatus? status,
    String? message,
    List<OrganizationModel>? organizationsList,
    List<BranchOfficeModel>? branchesList,
    List<DepartmentModel>? departmentsList,
    List<TeamModel>? teamsList,
    OrganizationModel? selectedOrganization,
    BranchOfficeModel? selectedBranch,
    DepartmentModel? selectedDepartment,
    TeamModel? selectedTeam,
    UserType? userType,
    WorkStatus? workStatus,
    bool? isValidEmail,
  }) {
    return NewUserState(
      status: status ?? this.status,
      message: message ?? this.message,
      organizationsList: organizationsList ?? this.organizationsList,
      branchesList: branchesList ?? this.branchesList,
      departmentsList: departmentsList ?? this.departmentsList,
      teamsList: teamsList ?? this.teamsList,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      selectedTeam: selectedTeam ?? this.selectedTeam,
      userType: userType ?? this.userType,
      workStatus: workStatus ?? this.workStatus,
      isValidEmail: isValidEmail ?? this.isValidEmail,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        organizationsList,
        branchesList,
        departmentsList,
        teamsList,
        selectedOrganization,
        selectedBranch,
        selectedDepartment,
        selectedTeam,
        userType,
        workStatus,
        isValidEmail,
      ];
}
