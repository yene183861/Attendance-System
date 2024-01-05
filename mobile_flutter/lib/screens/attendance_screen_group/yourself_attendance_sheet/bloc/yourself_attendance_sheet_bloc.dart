import 'package:equatable/equatable.dart';
import 'package:firefly/data/model/attendance_model.dart';
import 'package:firefly/data/model/attendance_statistics_model.dart';
import 'package:firefly/data/request_param/get_attendance_param.dart';
import 'package:firefly/services/repository/attendance_repository.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/services/api/error_from_server.dart';
import 'package:firefly/utils/date_time_ext.dart';

part 'yourself_attendance_sheet_event.dart';
part 'yourself_attendance_sheet_state.dart';

class YourselfAttendanceSheetBloc
    extends Bloc<YourselfAttendanceSheetEvent, YourselfAttendanceSheetState> {
  YourselfAttendanceSheetBloc()
      : super(YourselfAttendanceSheetState(
            month: DateTime.now().lastDateOfMonth, day: DateTime.now())) {
    on<GetAttendanceEvent>(_onGetAttendanceEvent);
    on<GetAttendanceStatisticsEvent>(_onGetAttendanceStatisticsEvent);
    on<ChangeWorkingDayEvent>(_onChangeWorkingDayEvent);
  }
  final attendanceRepo = AttendanceRepository();

  void _onGetAttendanceEvent(GetAttendanceEvent event,
      Emitter<YourselfAttendanceSheetState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.pure,
      message: '',
    ));
    try {
      final param = GetAttendanceParam(
          userId: Singleton.instance.userProfile!.id, workingDay: state.day);
      final res = await attendanceRepo.getAttendancesList(param: param);
      emit(state.copyWith(
        status: FormzStatus.pure,
        message: '',
        listAttendance: res?.data,
      ));
    } on ErrorFromServer catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, message: e.message));
    }
  }

  void _onGetAttendanceStatisticsEvent(GetAttendanceStatisticsEvent event,
      Emitter<YourselfAttendanceSheetState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.pure,
      message: '',
    ));
    try {
      final res = await attendanceRepo.getAttendancesStatistics(
          userId: Singleton.instance.userProfile!.id!, month: state.month!);
      emit(state.copyWith(
        status: FormzStatus.pure,
        message: '',
        attendanceStatisticsModel: res?.data,
      ));
    } on ErrorFromServer catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, message: e.message));
    }
  }

  void _onChangeWorkingDayEvent(ChangeWorkingDayEvent event,
      Emitter<YourselfAttendanceSheetState> emit) async {
    emit(state.copyWith(
      day: event.day,
      month: event.day.lastDateOfMonth,
    ));
    add(GetAttendanceEvent());
    if (state.month != event.day.lastDateOfMonth) {
      add(GetAttendanceStatisticsEvent());
    }
  }
}

extension BlocExt on BuildContext {
  YourselfAttendanceSheetBloc get yourselfAttendanceSheetBloc =>
      read<YourselfAttendanceSheetBloc>();
}
