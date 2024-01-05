import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firefly/data/model/ticket_model.dart';
import 'package:firefly/data/model/user_model.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/utils.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/face_attendance_model.dart';

import '../enum_type/work_type.dart';

class AttendanceModel extends Equatable {
  final int? id;
  final UserModel user;
  final WorkType workType;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool status;
  final double workingHours;
  final double workNumber;
  final String workingDay;
  final bool? isLateIn;
  final bool? isEarlyOut;
  final int minutesLateIn;
  final int minutesEarlyOut;
  // final double overtimeWork;
  final double overtimeHour;
  final List<FaceAttendanceModel>? faceAttendances;
  final List<TicketModel>? tickets;

  const AttendanceModel({
    this.id,
    required this.user,
    required this.workType,
    required this.startTime,
    this.endTime,
    this.status = true,
    this.workingHours = 0.0,
    this.workNumber = 0.0,
    required this.workingDay,
    this.isLateIn = false,
    this.isEarlyOut = false,
    this.minutesLateIn = 0,
    this.minutesEarlyOut = 0,
    // this.overtimeWork = 0.0,
    this.overtimeHour = 0.0,
    this.faceAttendances,
    this.tickets,
  });

  factory AttendanceModel.fromJson(JSON json) {
    return AttendanceModel(
      id: json['id'].integerValue,
      user: UserModel.fromJson(json['user']),
      workType: WorkTypeHelper.convertType(json['work_type'].integerValue),
      startTime: DateFormat(DateTimePattern.dateFormatPromotion3)
          .parse(json['start_time'].stringValue),
      endTime: json['end_time'].stringValue.isNotEmpty
          ? DateFormat(DateTimePattern.dateFormatPromotion3)
              .parse(json['end_time'].stringValue)
          : null,
      workingHours: json['working_hours'].ddoubleValue,
      workNumber: json['work_number'].ddoubleValue,
      workingDay: json['working_day'].stringValue,
      isLateIn: json['is_late_in'].booleanValue,
      isEarlyOut: json['is_early_out'].booleanValue,
      minutesLateIn: json['minutes_late_in'].integerValue,
      minutesEarlyOut: json['minutes_early_out'].integerValue,
      faceAttendances: json['face_attendances']
          .listValue
          .map((e) => FaceAttendanceModel.fromJson(e))
          .toList(),
      // overtimeWork: json['overtime_work'].ddoubleValue,
      overtimeHour: json['overtime_hour'].ddoubleValue,
      tickets: json['tickets']
          .listValue
          .map((e) => TicketModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['user'] = user.id;
    data['work_type'] = workType.type;
    data['start_time'] = Utils.formatDateTimeToString(
      time: startTime ?? DateTime.now(),
      dateFormat: DateFormat(DateTimePattern.dateFormatPromotion3),
    );
    data['end_time'] = Utils.formatDateTimeToString(
      time: endTime ?? DateTime.now(),
      dateFormat: DateFormat(DateTimePattern.dateFormatPromotion3),
    );
    data['working_hours'] = workingHours;
    data['working_day'] = workingDay;
    data['is_late_in'] = isLateIn;
    data['is_early_out'] = isEarlyOut;
    data['minutes_late_in'] = minutesLateIn;
    data['minutes_early_out'] = minutesEarlyOut;
    // data['overtime_work'] = overtimeWork;
    data['overtime_hour'] = overtimeHour;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        user,
        workType,
        startTime,
        endTime,
        status,
        workingHours,
        workNumber,
        workingDay,
        isLateIn,
        isEarlyOut,
        minutesLateIn,
        minutesEarlyOut,
        // overtimeWork,
        overtimeHour,
        faceAttendances,
        tickets,
      ];
}
