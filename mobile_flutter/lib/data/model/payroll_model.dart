import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:g_json/g_json.dart';

import 'user_model.dart';

class PayrollModel extends Equatable {
  final int? id;
  final UserModel? user;
  final DateTime? month;
  final double? realField;
  final double? totalSalary;
  final double? totalAllowance;
  final double? totalBonus;
  final double? totalPunish;
  final double? penaltyBeingLate;
  final double? earlyReturnPenalty;
  final double? penaltyLeavingWithoutReason;
  final double? penaltyForgettingAttendance;
  final double? insurance;
  final double? tax;
  final bool? isClosed;

  const PayrollModel({
    this.id,
    this.user,
    this.month,
    this.realField,
    this.totalSalary,
    this.totalAllowance,
    this.totalBonus,
    this.totalPunish,
    this.insurance,
    this.tax,
    this.isClosed,
    this.penaltyBeingLate,
    this.earlyReturnPenalty,
    this.penaltyLeavingWithoutReason,
    this.penaltyForgettingAttendance,
  });

  factory PayrollModel.fromJson(JSON json) {
    return PayrollModel(
      id: json['id'].integerValue,
      user: UserModel.fromJson(json['user']),
      month:
          DateFormat(DateTimePattern.dayType2).parse(json['month'].stringValue),
      realField: json['real_field'].ddoubleValue,
      totalSalary: json['total_salary'].ddoubleValue,
      totalAllowance: json['total_allowance'].ddoubleValue,
      totalBonus: json['total_bonus'].ddoubleValue,
      totalPunish: json['total_punish'].ddoubleValue,
      insurance: json['insurance'].ddoubleValue,
      tax: json['tax'].ddoubleValue,
      isClosed: json['is_closed'].booleanValue,
      penaltyBeingLate: json['penalty_being_late'].ddoubleValue,
      earlyReturnPenalty: json['early_return_penalty'].ddoubleValue,
      penaltyLeavingWithoutReason:
          json['penalty_leaving_without_reason'].ddoubleValue,
      penaltyForgettingAttendance:
          json['penalty_forgetting_attendance'].ddoubleValue,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        user,
        month,
        realField,
        totalSalary,
        totalAllowance,
        totalBonus,
        totalPunish,
        insurance,
        tax,
        isClosed,
        penaltyBeingLate,
        earlyReturnPenalty,
        penaltyLeavingWithoutReason,
        penaltyForgettingAttendance,
      ];
}
