import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/enum_type/by_time.dart';
import 'package:firefly/data/enum_type/ticket_status.dart';
import 'package:firefly/data/enum_type/ticket_type.dart';
import 'package:firefly/data/model/date_time_ticket_model.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/ticket_model.dart';
import 'package:firefly/data/model/ticket_reason_model.dart';
import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/data/request_param/get_ticket_reason_param.dart';
import 'package:firefly/services/api/barrel_api.dart';
import 'package:firefly/services/repository/organization_repository.dart';
import 'package:firefly/services/repository/ticket_reason_repository.dart';
import 'package:firefly/services/repository/ticket_repository.dart';
import 'package:firefly/services/repository/user_repository.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/utils.dart';

part 'edit_ticket_event.dart';
part 'edit_ticket_state.dart';

class EditTicketBloc extends Bloc<EditTicketEvent, EditTicketState> {
  EditTicketBloc({TicketModel? ticket})
      : super(EditTicketState(
          ticketType: ticket != null
              ? ticket.ticketType
              : TicketType.APPLICATION_FOR_THOUGHT,
          startDate: ticket != null
              ? ticket.dateTimeTickets![0].startDateTime
              // DateFormat(DateTimePattern.dayType2)
              //     .parse(ticket.dateTimeTickets![0].startDate)
              : DateTime.now(),
          endDate: ticket != null
              ? ticket.dateTimeTickets![0].endDateTime
              // DateFormat(DateTimePattern.dayType2)
              //     .parse(ticket.dateTimeTickets![0].endDate)
              : DateTime.now(),
          startTime: Utils.formatDateTimeToString(
              time: ticket != null
                  ? ticket.dateTimeTickets![0].startDateTime
                  : Utils.floorToNearest30Minutes(DateTime.now()),
              dateFormat: DateFormat(DateTimePattern.timeType)),
          endTime: Utils.formatDateTimeToString(
              time: ticket != null
                  ? ticket.dateTimeTickets![0].endDateTime
                  : Utils.floorToNearest30Minutes(DateTime.now()),
              dateFormat: DateFormat(DateTimePattern.timeType)),
          selectedTicketReason:
              ticket != null ? ticket.dateTimeTickets![0].ticketReason : null,
          ticketReasonsList:
              ticket != null ? [ticket.dateTimeTickets![0].ticketReason] : null,
          ticket: ticket,
        )) {
    on<InitEvent>(_onInitEvent);
    on<GetTicketReasonEvent>(_onGetTicketReasonEvent);
    on<ChangeTicketTypeEvent>(_onChangeTicketTypeEvent);
    on<ChangeTicketReasonEvent>(_onChangeTicketReasonEvent);
    on<ChangeStartDateEvent>(_onChangeStartDateEvent);
    on<ChangeEndDateEvent>(_onChangeEndDateEvent);
    on<ChangeStartTimeEvent>(_onChangeStartTimeEvent);
    on<ChangeEndTimeEvent>(_onChangeEndTimeEvent);
    on<CreateTicketEvent>(_onCreateTicketEvent);
    on<UpdateTicketEvent>(_onUpdateTicketEvent);

    // on<UpdateTicketEvent>(_onUpdateTicketEvent);
    // on<ChangeTicketStatusEvent>(_onChangeTicketStatusEvent);
    // on<SearchUserEvent>(_onSearchUserEvent);
    // on<SelectUserEvent>(_onSelectUserEvent);
  }
  final ticketReasonRepo = TicketReasonRepository();
  final orgRepo = OrganizationRepository();
  final userRepo = UserRepository();
  final ticketRepo = TicketRepository();
  final thoughtList = ['Nửa ca đầu', 'Nửa ca sau'];
  final timeList = Utils.generateTimeList();

  void _onInitEvent(InitEvent event, Emitter<EditTicketState> emit) async {
    if (state.ticketType != TicketType.APPLICATION_FOR_THOUGHT) {
      emit(state.copyWith(timeList: timeList));
    } else {
      var startTime = thoughtList[0];
      var endTime = thoughtList[1];

      if (state.ticket != null) {
        final sTime = Utils.formatDateTimeToString(
            time: state.ticket!.dateTimeTickets![0].startDateTime,
            dateFormat: DateFormat(DateTimePattern.timeType));
        final eTime = Utils.formatDateTimeToString(
            time: state.ticket!.dateTimeTickets![0].endDateTime,
            dateFormat: DateFormat(DateTimePattern.timeType));
        startTime = sTime == '08:30' ? thoughtList[0] : thoughtList[1];
        endTime = eTime == '12:00' ? thoughtList[0] : thoughtList[1];
      }
      emit(
        state.copyWith(
            timeList: thoughtList, startTime: startTime, endTime: endTime),
      );
    }
    add(GetTicketReasonEvent());
  }

  void _onGetTicketReasonEvent(
      GetTicketReasonEvent event, Emitter<EditTicketState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      final param = GetTicketReasonParam(
          // organizationId: state.selectedOrganization!.id!,
          organizationId: Singleton.instance.userWork!.organization!.id!,
          ticketType: state.ticketType);
      final res = await ticketReasonRepo.getTicketReasons(param: param);

      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: '',
          ticketReasonsList: res?.data,
        ),
      );
      if (res?.data != null && res!.data!.isNotEmpty) {
        add(ChangeTicketReasonEvent(tickerReason: res.data![0]));
      } else {
        emit(
          state.copyWith(
              selectedTicketReason: TicketReasonModel(
                  organizationId: 0,
                  ticketType: TicketType.ABSENCE_APPLICATION,
                  name: '',
                  maximum: 0,
                  byTime: ByTime.DAY)),
        );
      }
    } on ErrorFromServer catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          message: e.message,
        ),
      );
    }
  }

  void _onChangeTicketTypeEvent(
      ChangeTicketTypeEvent event, Emitter<EditTicketState> emit) async {
    if (state.ticketType != event.ticketType) {
      if (event.ticketType == TicketType.APPLICATION_FOR_THOUGHT) {
        emit(state.copyWith(
          ticketType: event.ticketType,
          timeList: thoughtList,
          startTime: thoughtList[0],
          endTime: thoughtList[1],
        ));
      } else {
        emit(state.copyWith(
          ticketType: event.ticketType,
          timeList: timeList,
          startTime: '08:30',
          endTime: '',
        ));
      }
      add(GetTicketReasonEvent());
    }
  }

  void _onChangeTicketReasonEvent(
      ChangeTicketReasonEvent event, Emitter<EditTicketState> emit) async {
    emit(state.copyWith(selectedTicketReason: event.tickerReason));
  }

  void _onChangeStartDateEvent(
      ChangeStartDateEvent event, Emitter<EditTicketState> emit) async {
    emit(state.copyWith(status: FormzStatus.pure, message: ''));
    var startTime = state.startTime!;
    var endTime = state.endTime!;
    if (state.ticketType == TicketType.APPLICATION_FOR_THOUGHT) {
      startTime = startTime == thoughtList[0] ? '08:30' : '13:00';
      endTime = endTime == thoughtList[0] ? '12:00' : '17:30';
    }
    final sDt = combineDateTime(date: event.startDate, time: startTime);
    final eDt = combineDateTime(date: state.endDate!, time: endTime);

    if (state.ticketType != TicketType.APPLICATION_FOR_THOUGHT) {
      if (sDt.isAfter(eDt)) {
        emit(
          state.copyWith(
              status: FormzStatus.submissionSuccess,
              message: '',
              startDate: event.startDate,
              endDate: event.startDate),
        );
      } else {
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: '',
            startDate: event.startDate,
          ),
        );
      }
    } else {
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: '',
        endDate: event.startDate,
        startDate: event.startDate,
      ));
    }
  }

  void _onChangeEndDateEvent(
      ChangeEndDateEvent event, Emitter<EditTicketState> emit) async {
    emit(state.copyWith(status: FormzStatus.pure, message: ''));
    var startTime = state.startTime!;
    var endTime = state.endTime!;
    if (state.ticketType == TicketType.APPLICATION_FOR_THOUGHT) {
      startTime = startTime == thoughtList[0] ? '08:30' : '13:00';
      endTime = endTime == thoughtList[0] ? '12:00' : '17:30';
    }
    final sDt = combineDateTime(date: state.startDate!, time: startTime);
    final eDt = combineDateTime(date: event.endDate, time: endTime);
    if (state.ticketType != TicketType.APPLICATION_FOR_THOUGHT) {
      if (sDt.isAfter(eDt)) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionFailure,
            message: 'Ngày giờ kết thúc phải sau ngày giờ bắt đầu',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: '',
            endDate: event.endDate,
          ),
        );
      }
    } else {
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: '',
        endDate: event.endDate,
        startDate: event.endDate,
      ));
    }
  }

  void _onChangeStartTimeEvent(
      ChangeStartTimeEvent event, Emitter<EditTicketState> emit) async {
    emit(state.copyWith(status: FormzStatus.pure, message: ''));

    if (state.ticketType != TicketType.CHECK_IN_OUT_FORM) {
      var startTime = event.startTime;
      var endTime = state.endTime!;
      if (state.ticketType == TicketType.APPLICATION_FOR_THOUGHT) {
        startTime = startTime == thoughtList[0] ? '08:30' : '13:00';
        endTime = endTime == thoughtList[0] ? '12:00' : '17:30';
      }

      final start = combineDateTime(date: state.startDate!, time: startTime);

      final end = combineDateTime(date: state.endDate!, time: endTime);
      if (start.isAfter(end) || start.difference(end).inMinutes == 0) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionFailure,
            message: 'Ngày giờ kết thúc phải sau ngày giờ bắt đầu',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: '',
            startTime: event.startTime,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: '',
          startTime: event.startTime,
          endTime: event.startTime,
        ),
      );
    }
  }

  void _onChangeEndTimeEvent(
      ChangeEndTimeEvent event, Emitter<EditTicketState> emit) async {
    emit(state.copyWith(status: FormzStatus.pure, message: ''));
    if (state.ticketType != TicketType.CHECK_IN_OUT_FORM) {
      var startTime = state.startTime!;
      var endTime = event.endTime;
      if (state.ticketType == TicketType.APPLICATION_FOR_THOUGHT) {
        startTime = startTime == thoughtList[0] ? '08:30' : '13:00';
        endTime = endTime == thoughtList[0] ? '12:00' : '17:30';
      }

      final start = combineDateTime(date: state.startDate!, time: startTime);

      final end = combineDateTime(date: state.endDate!, time: endTime);
      if (start.isAfter(end) || start.difference(end).inMinutes == 0) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionFailure,
            message: 'Ngày giờ kết thúc phải sau ngày giờ bắt đầu',
          ),
        );
        print('go heeeee but still change');
        print(state.endTime);
      } else {
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: '',
            endTime: event.endTime,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: '',
          startTime: event.endTime,
          endTime: event.endTime,
        ),
      );
    }
  }

  void _onCreateTicketEvent(
      CreateTicketEvent event, Emitter<EditTicketState> emit) async {
    emit(
      state.copyWith(
        status: FormzStatus.submissionInProgress,
        message: '',
      ),
    );
    if (state.selectedTicketReason == null ||
        state.selectedTicketReason?.id == null ||
        state.selectedTicketReason?.id == 0) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          message: 'Bạn phải chọn lý do cho đơn xin nghỉ',
        ),
      );
      return;
    }
    var endTime = state.endTime!;
    var startTime = state.startTime!;
    if (state.ticketType == TicketType.APPLICATION_FOR_THOUGHT) {
      startTime = startTime == thoughtList[0] ? '08:30' : '13:00';
      endTime = endTime == thoughtList[0] ? '12:00' : '17:30';
    }
    try {
      final dateTimeTickets = DateTimeTicketModel(
        ticketReason: state.selectedTicketReason!,
        endDateTime: combineDateTime(date: state.endDate!, time: endTime),
        startDateTime: combineDateTime(date: state.startDate!, time: startTime),
        // endTime: state.endTime,
        // startTime: state.startTime,
      );
      final model = TicketModel(
        user: Singleton.instance.userProfile,
        ticketType: state.ticketType,
        status: TicketStatus.PENDING,
        description: event.description,
        dateTimeTickets: [dateTimeTickets],
      );
      await ticketRepo.addTicket(model: model);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'Tạo ticket thành công',
        ),
      );
    } on ErrorFromServer catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          message: e.message,
        ),
      );
    }
  }

  void _onUpdateTicketEvent(
      UpdateTicketEvent event, Emitter<EditTicketState> emit) async {
    emit(
      state.copyWith(
        status: FormzStatus.submissionInProgress,
        message: '',
      ),
    );
    if (state.selectedTicketReason == null ||
        state.selectedTicketReason?.id == null ||
        state.selectedTicketReason?.id == 0) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          message: 'Bạn phải chọn lý do cho đơn xin nghỉ',
        ),
      );
      return;
    }
    var endTime = state.endTime!;
    var startTime = state.startTime!;
    if (state.ticketType == TicketType.APPLICATION_FOR_THOUGHT) {
      startTime = startTime == thoughtList[0] ? '08:30' : '13:00';
      endTime = endTime == thoughtList[0] ? '12:00' : '17:30';
    }
    try {
      final dateTimeTickets = DateTimeTicketModel(
        ticketReason: state.selectedTicketReason!,
        endDateTime: combineDateTime(date: state.endDate!, time: endTime),
        startDateTime: combineDateTime(date: state.startDate!, time: startTime),
      );
      final model = TicketModel(
        user: Singleton.instance.userProfile,
        ticketType: state.ticketType,
        status: TicketStatus.PENDING,
        description: event.description,
        dateTimeTickets: [dateTimeTickets],
      );
      await ticketRepo.updateTicket(model: model, id: state.ticket!.id!);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'update ticket thành công'.tr(),
        ),
      );
    } on ErrorFromServer catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          message: e.message,
        ),
      );
    }
  }

  // void _onChangeTicketStatusEvent(
  //     ChangeTicketStatusEvent event, Emitter<EditTicketState> emit) async {
  //   emit(
  //     state.copyWith(
  //       ticketStatus: event.ticketStatus,
  //     ),
  //   );
  // }

  // void _onSearchUserEvent(
  //     SearchUserEvent event, Emitter<EditTicketState> emit) async {
  //   emit(
  //     state.copyWith(
  //       status: FormzStatus.submissionInProgress,
  //       message: '',
  //     ),
  //   );
  //   try {
  //     final res = await userRepo.searchUserWorkByName(name: event.text);
  //     emit(
  //       state.copyWith(
  //         status: FormzStatus.submissionSuccess,
  //         message: '',
  //         users: res?.data,
  //       ),
  //     );
  //   } on ErrorFromServer catch (e) {
  //     emit(
  //       state.copyWith(
  //         status: FormzStatus.submissionFailure,
  //         message: e.message,
  //       ),
  //     );
  //   }
  // }

  // void _onSelectUserEvent(
  //     SelectUserEvent event, Emitter<EditTicketState> emit) async {
  //   emit(
  //     state.copyWith(
  //       selectedUser: event.userWorkModel,
  //     ),
  //   );
  // }

  DateTime combineDateTime({required DateTime date, required String time}) {
    print('\n');
    print(time);

    List<String> timeParts = time.split(':');

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    DateTime resultDateTime =
        DateTime(date.year, date.month, date.day, hour, minute);
    return resultDateTime;
  }
}

extension BlocExt on BuildContext {
  EditTicketBloc get editTicketBloc => read<EditTicketBloc>();
}
