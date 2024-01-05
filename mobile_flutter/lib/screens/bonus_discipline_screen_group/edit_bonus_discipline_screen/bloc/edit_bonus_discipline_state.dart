part of 'edit_bonus_discipline_bloc.dart';

class EditBonusDisciplineState extends Equatable {
  final FormzStatus status;
  final String? message;
  final List<UserWorkModel>? users;
  final UserWorkModel? selectedUser;
  final List<OrganizationModel>? organizationsList;
  final List<BranchOfficeModel>? branchList;
  final List<DepartmentModel>? departmentList;
  final List<TeamModel>? teamList;
  final OrganizationModel? selectedOrganization;
  final BranchOfficeModel? selectedBranch;
  final DepartmentModel? selectedDepartment;
  final TeamModel? selectedTeam;
  final DateTime? month;
  final bool isReward;
  final RewardOrDisciplineModel? rewardOrDisModel;

  const EditBonusDisciplineState({
    this.status = FormzStatus.pure,
    this.message,
    this.users,
    this.selectedUser,
    this.organizationsList,
    this.branchList,
    this.departmentList,
    this.teamList,
    this.selectedOrganization,
    this.selectedBranch,
    this.selectedDepartment,
    this.selectedTeam,
    this.month,
    this.isReward = true,
    this.rewardOrDisModel,
  });

  EditBonusDisciplineState copyWith({
    FormzStatus? status,
    String? message,
    List<UserWorkModel>? users,
    UserWorkModel? selectedUser,
    List<OrganizationModel>? organizationsList,
    List<BranchOfficeModel>? branchList,
    List<DepartmentModel>? departmentList,
    List<TeamModel>? teamList,
    OrganizationModel? selectedOrganization,
    BranchOfficeModel? selectedBranch,
    DepartmentModel? selectedDepartment,
    TeamModel? selectedTeam,
    DateTime? month,
    bool? isReward,
    RewardOrDisciplineModel? rewardOrDisModel,
  }) {
    return EditBonusDisciplineState(
      status: status ?? this.status,
      message: message ?? this.message,
      users: users ?? this.users,
      selectedUser: selectedUser ?? this.selectedUser,
      organizationsList: organizationsList ?? this.organizationsList,
      branchList: branchList ?? this.branchList,
      departmentList: departmentList ?? this.departmentList,
      teamList: teamList ?? this.teamList,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      selectedTeam: selectedTeam ?? this.selectedTeam,
      month: month ?? this.month,
      isReward: isReward ?? this.isReward,
      rewardOrDisModel: rewardOrDisModel ?? this.rewardOrDisModel,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        users,
        selectedUser,
        organizationsList,
        branchList,
        departmentList,
        teamList,
        selectedOrganization,
        selectedBranch,
        selectedDepartment,
        selectedTeam,
        month,
        isReward,
        rewardOrDisModel,
      ];
}
