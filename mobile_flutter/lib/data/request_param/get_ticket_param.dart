import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/data/enum_type/ticket_status.dart';
import 'package:firefly/data/enum_type/ticket_type.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/utils.dart';

class GetTicketParam {
  final int? ticketReasonId;
  final int? userId;
  final int? organizationId;
  final int? branchOfficeId;
  final int? departmentId;
  final int? teamId;
  final TicketStatus? status;
  final TicketType? ticketType;
  final DateTime month;

  GetTicketParam({
    this.ticketReasonId,
    this.userId,
    this.organizationId,
    this.branchOfficeId,
    this.departmentId,
    this.teamId,
    this.status,
    this.ticketType,
    required this.month,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (ticketReasonId != null) data['ticket_reason_id'] = ticketReasonId;
    if (userId != null) data['user_id'] = userId;
    if (organizationId != null) data['organization_id'] = organizationId;
    if (branchOfficeId != null) data['branch_office_id'] = branchOfficeId;
    if (departmentId != null) data['department_id'] = departmentId;
    if (teamId != null) data['team_id'] = teamId;
    if (status != null) data['status'] = status!.type;
    if (ticketType != null) data['ticket_type'] = ticketType!.type;
    data['month'] = Utils.formatDateTimeToString(
        time: month, dateFormat: DateFormat(DateTimePattern.dayType2));
    return data;
  }
}
