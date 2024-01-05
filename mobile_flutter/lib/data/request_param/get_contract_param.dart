import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/data/enum_type/contract_status.dart';
import 'package:firefly/data/enum_type/contract_type.dart';
import 'package:firefly/data/enum_type/ticket_status.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/utils.dart';

class GetContractParam {
  final int? organizationId;
  final int? branchOfficeId;
  final int? departmentId;
  final int? teamId;
  final ContractStatus? state;
  final TicketStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? contractCode;
  final ContractType? contractType;
  final int? userId;
  final int? creatorId;

  GetContractParam({
    this.organizationId,
    this.branchOfficeId,
    this.departmentId,
    this.teamId,
    this.state,
    this.status,
    this.startDate,
    this.endDate,
    this.contractCode,
    this.userId,
    this.contractType,
    this.creatorId,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (contractCode != null) data['contract_code'] = contractCode;
    if (userId != null) data['user_id'] = userId;
    if (creatorId != null) data['creator_id'] = creatorId;
    if (organizationId != null) data['organization_id'] = organizationId;
    if (branchOfficeId != null) data['branch_office_id'] = branchOfficeId;
    if (departmentId != null) data['department_id'] = departmentId;
    if (teamId != null) data['team_id'] = teamId;
    if (status != null) data['status'] = status?.type;
    if (state != null) data['state'] = state?.type;
    if (contractType != null) data['contract_type'] = contractType?.type;
    if (startDate != null) {
      data['start_date'] = Utils.formatDateTimeToString(
          time: startDate!, dateFormat: DateFormat(DateTimePattern.dayType2));
    }
    if (endDate != null) {
      data['end_date'] = Utils.formatDateTimeToString(
          time: endDate!, dateFormat: DateFormat(DateTimePattern.dayType2));
    }
    return data;
  }
}
