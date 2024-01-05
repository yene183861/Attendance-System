part of 'detail_ticket_bloc.dart';

class DetailTicketState extends Equatable {
  const DetailTicketState({
    this.status = FormzStatus.pure,
    this.message,
    // this.ticketType = TicketType.APPLICATION_FOR_THOUGHT,

    this.ticket,
    this.userWork,
    this.isChangeData = false,
  });

  final FormzStatus status;
  final String? message;
  // final TicketType ticketType;
  // final List<TicketReasonModel>? ticketReasonsList;
  final TicketModel? ticket;
  // final UserModel? selectedUser;
  // final List<OrganizationModel>? organizationsList;
  // final OrganizationModel? selectedOrganization;
  // final bool isFilterByTicketType;
  // final ByTime? byTime;
  // final bool isFilterByTime;
  final UserWorkModel? userWork;
  final bool isChangeData;

  DetailTicketState copyWith({
    FormzStatus? status,
    String? message,
    // TicketType? ticketType,
    // UserModel? selectedUser,
    TicketModel? ticket,
    // List<TicketReasonModel>? ticketReasonsList,
    // List<OrganizationModel>? organizationsList,
    // OrganizationModel? selectedOrganization,
    // bool? isFilterByTicketType,
    // bool? isFilterByTime,
    // ByTime? byTime,
    UserWorkModel? userWork,
    bool? isChangeData,
  }) {
    return DetailTicketState(
      status: status ?? this.status,
      message: message ?? this.message,
      // ticketType: ticketType ?? this.ticketType,
      // ticketReasonsList: ticketReasonsList ?? this.ticketReasonsList,
      // organizationsList: organizationsList ?? this.organizationsList,
      // selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      // isFilterByTicketType: isFilterByTicketType ?? this.isFilterByTicketType,
      // isFilterByTime: isFilterByTime ?? this.isFilterByTime,
      // selectedUser: selectedUser ?? this.selectedUser,
      ticket: ticket ?? this.ticket,
      // byTime: byTime ?? this.byTime,
      userWork: userWork ?? this.userWork,
      isChangeData: isChangeData ?? this.isChangeData,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        // ticketType,
        // ticketReasonsList,
        // organizationsList,
        // selectedOrganization,
        // isFilterByTicketType,
        // isFilterByTime,
        // byTime,
        ticket,
        // selectedUser,
        userWork,
        isChangeData,
      ];
}
