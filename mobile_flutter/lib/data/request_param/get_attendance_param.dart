import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/utils.dart';
import 'package:firefly/utils/date_time_ext.dart';

class GetAttendanceParam {
  final int? userId;
  final int? organizationId;
  final int? branchOfficeId;
  final int? departmentId;
  final int? teamId;

  final DateTime? workingDay;
  final DateTime? month;

  GetAttendanceParam({
    this.userId,
    this.organizationId,
    this.branchOfficeId,
    this.departmentId,
    this.teamId,
    this.workingDay,
    this.month,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (userId != null) data['user_id'] = userId;
    if (organizationId != null) data['organization_id'] = organizationId;
    if (branchOfficeId != null) data['branch_office_id'] = branchOfficeId;
    if (departmentId != null) data['department_id'] = departmentId;
    if (teamId != null) data['team_id'] = teamId;
    if (month != null)
      data['month'] = Utils.formatDateTimeToString(
          time: month!.lastDateOfMonth,
          dateFormat: DateFormat(DateTimePattern.dayType2));
    ;
    if (workingDay != null)
      data['working_day'] = Utils.formatDateTimeToString(
          time: workingDay!, dateFormat: DateFormat(DateTimePattern.dayType2));
    return data;
  }
}
