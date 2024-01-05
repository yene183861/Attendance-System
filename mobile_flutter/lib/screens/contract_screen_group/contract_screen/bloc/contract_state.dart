part of 'contract_bloc.dart';

class ContractState extends Equatable {
  final FormzStatus status;
  final String? message;

  final UserWorkModel? selectedUser;
  final List<UserWorkModel>? users;
  final List<OrganizationModel>? organizationsList;
  final List<BranchOfficeModel>? branchList;
  final List<DepartmentModel>? departmentList;
  final List<TeamModel>? teamList;
  final OrganizationModel? selectedOrganization;
  final BranchOfficeModel? selectedBranch;
  final DepartmentModel? selectedDepartment;
  final TeamModel? selectedTeam;
  final List<ContractModel>? contractsList;
  final ContractStatus? contractStatus;
  final TicketStatus? contractState;
  final ContractType? contractType;
  final DateTime? startDate;
  final DateTime? endDate;

  const ContractState({
    this.status = FormzStatus.pure,
    this.message,
    this.selectedUser,
    this.users,
    this.organizationsList,
    this.branchList,
    this.departmentList,
    this.teamList,
    this.selectedOrganization,
    this.selectedBranch,
    this.selectedDepartment,
    this.selectedTeam,
    this.contractState,
    this.contractStatus,
    this.contractType,
    this.contractsList,
    this.endDate,
    this.startDate,
  });

  ContractState copyWith({
    FormzStatus? status,
    String? message,
    UserWorkModel? selectedUser,
    List<UserWorkModel>? users,
    List<OrganizationModel>? organizationsList,
    List<BranchOfficeModel>? branchList,
    List<DepartmentModel>? departmentList,
    List<TeamModel>? teamList,
    OrganizationModel? selectedOrganization,
    BranchOfficeModel? selectedBranch,
    DepartmentModel? selectedDepartment,
    TeamModel? selectedTeam,
    List<ContractModel>? contractsList,
    ContractStatus? contractStatus,
    TicketStatus? contractState,
    ContractType? contractType,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return ContractState(
      status: status ?? this.status,
      message: message ?? this.message,
      selectedUser: selectedUser ?? this.selectedUser,
      users: users ?? this.users,
      organizationsList: organizationsList ?? this.organizationsList,
      branchList: branchList ?? this.branchList,
      departmentList: departmentList ?? this.departmentList,
      teamList: teamList ?? this.teamList,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      selectedTeam: selectedTeam ?? this.selectedTeam,
      contractsList: contractsList ?? this.contractsList,
      contractStatus: contractStatus ?? this.contractStatus,
      contractState: contractState ?? this.contractState,
      contractType: contractType ?? this.contractType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        selectedUser,
        users,
        organizationsList,
        branchList,
        departmentList,
        teamList,
        selectedOrganization,
        selectedBranch,
        selectedDepartment,
        selectedTeam,
        contractsList,
        contractStatus,
        contractState,
        contractType,
        startDate,
        endDate,
      ];
}
