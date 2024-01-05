part of 'ticket_reason_bloc.dart';

class TicketReasonState extends Equatable {
  const TicketReasonState({
    this.status = FormzStatus.pure,
    this.message,
    this.ticketType = TicketType.APPLICATION_FOR_THOUGHT,
    this.ticketReasonsList,
    this.organizationsList,
    this.selectedOrganization,
    this.isFilterByTicketType = false,
    this.isFilterByTime = false,
    this.byTime = ByTime.MONTH,
  });

  final FormzStatus status;
  final String? message;
  final TicketType ticketType;
  final List<TicketReasonModel>? ticketReasonsList;
  final List<OrganizationModel>? organizationsList;
  final OrganizationModel? selectedOrganization;
  final bool isFilterByTicketType;
  final ByTime? byTime;
  final bool isFilterByTime;

  TicketReasonState copyWith({
    FormzStatus? status,
    String? message,
    TicketType? ticketType,
    List<TicketReasonModel>? ticketReasonsList,
    List<OrganizationModel>? organizationsList,
    OrganizationModel? selectedOrganization,
    bool? isFilterByTicketType,
    bool? isFilterByTime,
    ByTime? byTime,
  }) {
    return TicketReasonState(
      status: status ?? this.status,
      message: message ?? this.message,
      ticketType: ticketType ?? this.ticketType,
      ticketReasonsList: ticketReasonsList ?? this.ticketReasonsList,
      organizationsList: organizationsList ?? this.organizationsList,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      isFilterByTicketType: isFilterByTicketType ?? this.isFilterByTicketType,
      isFilterByTime: isFilterByTime ?? this.isFilterByTime,
      byTime: byTime ?? this.byTime,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        ticketType,
        ticketReasonsList,
        organizationsList,
        selectedOrganization,
        isFilterByTicketType,
        isFilterByTime,
        byTime,
      ];
}
