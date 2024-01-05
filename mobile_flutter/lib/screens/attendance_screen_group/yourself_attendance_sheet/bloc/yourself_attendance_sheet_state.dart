part of 'yourself_attendance_sheet_bloc.dart';

class YourselfAttendanceSheetState extends Equatable {
  final FormzStatus status;
  final String? message;
  final List<AttendanceModel>? listAttendance;
  final DateTime? day;
  final DateTime? month;
  final AttendanceStatisticsModel? attendanceStatisticsModel;

  const YourselfAttendanceSheetState({
    this.status = FormzStatus.pure,
    this.message,
    this.listAttendance,
    this.day,
    this.month,
    this.attendanceStatisticsModel,
  });

  YourselfAttendanceSheetState copyWith({
    FormzStatus? status,
    String? message,
    List<AttendanceModel>? listAttendance,
    DateTime? day,
    DateTime? month,
    AttendanceStatisticsModel? attendanceStatisticsModel,
  }) {
    return YourselfAttendanceSheetState(
      status: status ?? this.status,
      message: message ?? this.message,
      listAttendance: listAttendance ?? this.listAttendance,
      day: day ?? this.day,
      month: month ?? this.month,
      attendanceStatisticsModel:
          attendanceStatisticsModel ?? this.attendanceStatisticsModel,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        listAttendance,
        day,
        month,
        attendanceStatisticsModel,
      ];
}
