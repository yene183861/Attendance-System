import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:g_json/g_json.dart';

import 'user_model.dart';

class AttendanceStatisticsModel extends Equatable {
  final int? id;
  final UserModel? user;
  final DateTime? month;
  final double? actualWorkNumber;
  final int? standardWorkNumber;
  final int? timesLateIn;
  final int? minutesLateIn;
  final int? timesEarlyOut;
  final int? minutesEarlyOut;
  final double? offWithoutReason;
  final int? forgotCheckInOut;
  final double? overtimeHour;
  final double? otDailyWork;
  final double? otDayOff;
  final double? otHoliday;
  final bool? isClosed;

  const AttendanceStatisticsModel({
    this.id,
    this.user,
    this.month,
    this.actualWorkNumber,
    this.standardWorkNumber,
    this.timesLateIn,
    this.minutesLateIn,
    this.timesEarlyOut,
    this.minutesEarlyOut,
    this.offWithoutReason,
    this.forgotCheckInOut,
    this.overtimeHour,
    this.otDailyWork,
    this.otDayOff,
    this.otHoliday,
    this.isClosed,
  });

  factory AttendanceStatisticsModel.fromJson(JSON json) {
    return AttendanceStatisticsModel(
      id: json['id'].integerValue,
      user: UserModel.fromJson(json['user']),
      month: json['month'].stringValue.isNotEmpty
          ? DateFormat(DateTimePattern.dayType2)
              .parse(json['month'].stringValue)
          : DateTime.now(),
      actualWorkNumber: json['actual_work_number'].ddoubleValue,
      standardWorkNumber: json['standard_work_number'].integerValue,
      timesLateIn: json['times_late_in'].integerValue,
      minutesLateIn: json['minutes_late_in'].integerValue,
      timesEarlyOut: json['times-early_out'].integerValue,
      minutesEarlyOut: json['minutes_early_out'].integerValue,
      offWithoutReason: json['off_without_reason'].ddoubleValue,
      forgotCheckInOut: json['forgot_check_in_out'].integerValue,
      overtimeHour: json['overtime_hour'].ddoubleValue,
      otDailyWork: json['ot_daily_work'].ddoubleValue,
      otDayOff: json['ot_day_off'].ddoubleValue,
      otHoliday: json['ot_holiday'].ddoubleValue,
      isClosed: json['is_closed'].booleanValue,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        user,
        month,
        actualWorkNumber,
        standardWorkNumber,
        timesLateIn,
        minutesLateIn,
        timesEarlyOut,
        minutesEarlyOut,
        offWithoutReason,
        forgotCheckInOut,
        overtimeHour,
        otDailyWork,
        otDayOff,
        otHoliday,
        isClosed,
      ];
}
