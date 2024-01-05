part of 'manage_ticket_bloc.dart';

class ManageTicketState extends Equatable {
  const ManageTicketState({
    this.status = FormzStatus.pure,
    this.message,
    this.ticketType = TicketType.APPLICATION_FOR_THOUGHT,
    this.isFilterByTicketType = false,
    this.ticketReasonsList,
    this.selectedTicketReason,
    this.ticketList,
    this.organizationsList,
    this.branchesList,
    this.departmentsList,
    this.teamsList,
    this.selectedOrganization,
    this.selectedBranch,
    this.selectedDepartment,
    this.selectedTeam,
    this.ticketStatus = TicketStatus.PENDING,
    this.isFilterByTicketStatus = false,
    this.usersList,
    this.selectedUser,
    this.startDate,
    this.endDate,
  });

  final FormzStatus status;
  final String? message;
  final TicketType ticketType;

  final List<TicketReasonModel>? ticketReasonsList;
  final TicketReasonModel? selectedTicketReason;

  final List<TicketModel>? ticketList;

  final List<OrganizationModel>? organizationsList;
  final List<BranchOfficeModel>? branchesList;
  final List<DepartmentModel>? departmentsList;
  final List<TeamModel>? teamsList;

  final OrganizationModel? selectedOrganization;
  final BranchOfficeModel? selectedBranch;
  final DepartmentModel? selectedDepartment;
  final TeamModel? selectedTeam;

  final TicketStatus ticketStatus;

  final bool isFilterByTicketType;
  final bool isFilterByTicketStatus;

  final List<UserWorkModel>? usersList;
  final UserWorkModel? selectedUser;
  final DateTime? startDate;
  final DateTime? endDate;

  ManageTicketState copyWith({
    FormzStatus? status,
    String? message,
    TicketType? ticketType,
    List<TicketReasonModel>? ticketReasonsList,
    TicketReasonModel? selectedTicketReason,
    List<TicketModel>? ticketList,
    List<OrganizationModel>? organizationsList,
    List<BranchOfficeModel>? branchesList,
    List<DepartmentModel>? departmentsList,
    List<TeamModel>? teamsList,
    OrganizationModel? selectedOrganization,
    BranchOfficeModel? selectedBranch,
    DepartmentModel? selectedDepartment,
    TeamModel? selectedTeam,
    TicketStatus? ticketStatus,
    bool? isFilterByTicketType,
    bool? isFilterByTicketStatus,
    List<UserWorkModel>? usersList,
    UserWorkModel? selectedUser,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return ManageTicketState(
      status: status ?? this.status,
      message: message ?? this.message,
      ticketType: ticketType ?? this.ticketType,
      selectedTicketReason: selectedTicketReason ?? this.selectedTicketReason,
      ticketReasonsList: ticketReasonsList ?? this.ticketReasonsList,
      ticketList: ticketList ?? this.ticketList,
      organizationsList: organizationsList ?? this.organizationsList,
      branchesList: branchesList ?? this.branchesList,
      departmentsList: departmentsList ?? this.departmentsList,
      teamsList: teamsList ?? this.teamsList,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      selectedTeam: selectedTeam ?? this.selectedTeam,
      ticketStatus: ticketStatus ?? this.ticketStatus,
      isFilterByTicketType: isFilterByTicketType ?? this.isFilterByTicketType,
      isFilterByTicketStatus:
          isFilterByTicketStatus ?? this.isFilterByTicketStatus,
      selectedUser: selectedUser ?? this.selectedUser,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      usersList: usersList ?? this.usersList,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        ticketType,
        ticketList,
        selectedTicketReason,
        ticketReasonsList,
        organizationsList,
        branchesList,
        departmentsList,
        teamsList,
        selectedOrganization,
        selectedBranch,
        selectedDepartment,
        selectedTeam,
        isFilterByTicketType,
        isFilterByTicketStatus,
        startDate,
        endDate,
        ticketList,
        usersList,
        selectedUser,
      ];
}
