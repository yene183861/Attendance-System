part of 'ticket_bloc.dart';

class TicketState extends Equatable {
  const TicketState({
    this.status = FormzStatus.pure,
    this.message,
    this.ticketType = TicketType.APPLICATION_FOR_THOUGHT,
    this.ticketReasonsList,
    this.selectedUser,
    this.users,
    this.ticketList,
    this.organizationList,
    this.branchList,
    this.departmentList,
    this.teamList,
    this.selectedOrganization,
    this.selectedBranch,
    this.selectedDepartment,
    this.selectedTeam,
    this.isFilterByTicketType = false,
    this.isFilterByTicketStatus = false,
    this.ticketStatus = TicketStatus.PENDING,
    this.isYourTicket = true,
    required this.month,
  });

  final FormzStatus status;
  final String? message;
  final TicketType ticketType;
  final List<TicketReasonModel>? ticketReasonsList;
  final List<TicketModel>? ticketList;
  final UserWorkModel? selectedUser;
  final List<UserWorkModel>? users;
  final List<OrganizationModel>? organizationList;
  final List<BranchOfficeModel>? branchList;
  final List<DepartmentModel>? departmentList;
  final List<TeamModel>? teamList;

  final OrganizationModel? selectedOrganization;
  final BranchOfficeModel? selectedBranch;
  final DepartmentModel? selectedDepartment;
  final TeamModel? selectedTeam;
  final bool isFilterByTicketType;
  final bool isFilterByTicketStatus;
  final TicketStatus ticketStatus;
  final bool isYourTicket;
  final DateTime month;

  TicketState copyWith({
    FormzStatus? status,
    String? message,
    TicketType? ticketType,
    UserWorkModel? selectedUser,
    List<UserWorkModel>? users,
    List<TicketModel>? ticketList,
    List<TicketReasonModel>? ticketReasonsList,
    List<OrganizationModel>? organizationList,
    List<BranchOfficeModel>? branchList,
    List<DepartmentModel>? departmentList,
    List<TeamModel>? teamList,
    OrganizationModel? selectedOrganization,
    BranchOfficeModel? selectedBranch,
    DepartmentModel? selectedDepartment,
    TeamModel? selectedTeam,
    bool? isFilterByTicketType,
    bool? isFilterByTicketStatus,
    TicketStatus? ticketStatus,
    bool? isYourTicket,
    DateTime? month,
  }) {
    return TicketState(
      status: status ?? this.status,
      message: message ?? this.message,
      ticketType: ticketType ?? this.ticketType,
      ticketReasonsList: ticketReasonsList ?? this.ticketReasonsList,
      organizationList: organizationList ?? this.organizationList,
      branchList: branchList ?? this.branchList,
      departmentList: departmentList ?? this.departmentList,
      teamList: teamList ?? this.teamList,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      selectedTeam: selectedTeam ?? this.selectedTeam,
      isFilterByTicketType: isFilterByTicketType ?? this.isFilterByTicketType,
      isFilterByTicketStatus:
          isFilterByTicketStatus ?? this.isFilterByTicketStatus,
      selectedUser: selectedUser ?? this.selectedUser,
      ticketStatus: ticketStatus ?? this.ticketStatus,
      users: users ?? this.users,
      ticketList: ticketList ?? this.ticketList,
      isYourTicket: isYourTicket ?? this.isYourTicket,
      month: month ?? this.month,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        ticketType,
        ticketReasonsList,
        organizationList,
        branchList,
        departmentList,
        teamList,
        selectedOrganization,
        selectedBranch,
        selectedDepartment,
        selectedTeam,
        isFilterByTicketType,
        isFilterByTicketStatus,
        ticketStatus,
        ticketList,
        selectedUser,
        users,
        isYourTicket,
        month,
      ];
}
