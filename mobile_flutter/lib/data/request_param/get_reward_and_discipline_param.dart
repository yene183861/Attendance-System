import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/utils.dart';

class GetRewardAndDisciplineParam {
  final bool? isReward;
  final int? userId;
  final int? organizationId;
  final int? branchOfficeId;
  final int? departmentId;
  final int? teamId;
  final DateTime? month;

  GetRewardAndDisciplineParam({
    this.month,
    this.userId,
    this.organizationId,
    this.branchOfficeId,
    this.departmentId,
    this.teamId,
    this.isReward,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (month != null) {
      data['month'] = Utils.formatDateTimeToString(
          time: month!, dateFormat: DateFormat(DateTimePattern.dayType2));
    }
    if (userId != null) data['user_id'] = userId;
    if (organizationId != null) data['organization_id'] = organizationId;
    if (branchOfficeId != null) data['branch_office_id'] = branchOfficeId;
    if (departmentId != null) data['department_id'] = departmentId;
    if (teamId != null) data['team_id'] = teamId;
    if (isReward != null) data['is_reward'] = isReward;
    return data;
  }
}
