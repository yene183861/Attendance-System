part of 'edit_ticket_bloc.dart';

class EditTicketState extends Equatable {
  EditTicketState({
    this.status = FormzStatus.pure,
    this.message,
    required this.ticketType,
    this.ticketReasonsList,
    this.selectedTicketReason,
    this.ticket,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.timeList,
    // this.users,
    // this.selectedUser,
    // this.isCreateForYourself = true,
    // this.ticketStatus = TicketStatus.PENDING,
  });
  //  : startDate = startDate ?? DateTime.now(),
  //       endDate = endDate ?? DateTime.now();
  // startTime = startTime ??
  //     Utils.roundStringDateTime(
  //         time: Utils.formatDateTimeToString(
  //             time: DateTime.now(),
  //             dateFormat: DateFormat(DateTimePattern.timeType))),
  // endTime = endTime ??
  //     Utils.roundStringDateTime(
  //         time: Utils.formatDateTimeToString(
  //             time: DateTime.now().add(
  //               const Duration(minutes: 30),
  //             ),
  //             dateFormat: DateFormat(DateTimePattern.timeType)));

  final FormzStatus status;
  final String? message;
  final TicketType ticketType;
  final List<TicketReasonModel>? ticketReasonsList;
  final TicketReasonModel? selectedTicketReason;
  final TicketModel? ticket;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? startTime;
  final String? endTime;
  // final TicketStatus ticketStatus;
  final List<String>? timeList;
  // final List<UserWorkModel>? users;
  // final UserWorkModel? selectedUser;
  // final bool isCreateForYourself;

  EditTicketState copyWith({
    FormzStatus? status,
    String? message,
    TicketType? ticketType,
    List<TicketReasonModel>? ticketReasonsList,
    TicketReasonModel? selectedTicketReason,
    OrganizationModel? selectedOrganization,
    DateTime? startDate,
    DateTime? endDate,
    String? startTime,
    String? endTime,
    // TicketStatus? ticketStatus,
    List<String>? timeList,
    TicketModel? ticket,
    // List<UserWorkModel>? users,
    // UserModel? selectedUser,
    // bool? isCreateForYourself,
  }) {
    return EditTicketState(
      status: status ?? this.status,
      message: message ?? this.message,
      ticketType: ticketType ?? this.ticketType,
      ticketReasonsList: ticketReasonsList ?? this.ticketReasonsList,
      selectedTicketReason: selectedTicketReason ?? this.selectedTicketReason,
      // selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      ticket: ticket ?? this.ticket,
      timeList: timeList ?? this.timeList,
      // users: users ?? this.users,
      // selectedUser: selectedUser ?? this.selectedUser,
      // isCreateForYourself: isCreateForYourself ?? this.isCreateForYourself,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        ticketType,
        ticketReasonsList,
        selectedTicketReason,
        ticket,
        startDate,
        endDate,
        startTime,
        endTime,
        // ticketStatus,
        timeList,
        // users,
        // selectedUser,
        // isCreateForYourself,
      ];
}
