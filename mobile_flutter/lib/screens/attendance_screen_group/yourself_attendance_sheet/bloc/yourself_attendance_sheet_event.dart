part of 'yourself_attendance_sheet_bloc.dart';

abstract class YourselfAttendanceSheetEvent {}

class GetAttendanceEvent extends YourselfAttendanceSheetEvent {
  GetAttendanceEvent();
}

class GetAttendanceStatisticsEvent extends YourselfAttendanceSheetEvent {
  GetAttendanceStatisticsEvent();
}

class ChangeWorkingDayEvent extends YourselfAttendanceSheetEvent {
  final DateTime day;
  ChangeWorkingDayEvent({required this.day});
}
