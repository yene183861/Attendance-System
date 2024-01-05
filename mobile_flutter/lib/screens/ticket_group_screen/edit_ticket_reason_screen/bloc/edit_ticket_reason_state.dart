part of 'edit_ticket_reason_bloc.dart';

class EditTicketReasonState extends Equatable {
  const EditTicketReasonState({
    this.status = FormzStatus.pure,
    this.message,
    this.ticketType = TicketType.APPLICATION_FOR_THOUGHT,
    this.byTime = ByTime.MONTH,
    this.organizationsList,
    this.selectedOrganization,
    this.ticketReasonModel,
    this.isCaculWork = false,
  });

  final FormzStatus status;
  final String? message;
  final TicketType ticketType;
  final ByTime byTime;
  final List<OrganizationModel>? organizationsList;
  final OrganizationModel? selectedOrganization;
  final TicketReasonModel? ticketReasonModel;
  final bool isCaculWork;

  EditTicketReasonState copyWith({
    FormzStatus? status,
    String? message,
    TicketType? ticketType,
    ByTime? byTime,
    List<OrganizationModel>? organizationsList,
    OrganizationModel? selectedOrganization,
    TicketReasonModel? ticketReasonModel,
    bool? isCaculWork,
  }) {
    return EditTicketReasonState(
      status: status ?? this.status,
      message: message ?? this.message,
      ticketType: ticketType ?? this.ticketType,
      byTime: byTime ?? this.byTime,
      organizationsList: organizationsList ?? this.organizationsList,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      ticketReasonModel: ticketReasonModel ?? this.ticketReasonModel,
      isCaculWork: isCaculWork ?? this.isCaculWork,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        ticketType,
        byTime,
        organizationsList,
        selectedOrganization,
        ticketReasonModel,
        isCaculWork,
      ];
}
