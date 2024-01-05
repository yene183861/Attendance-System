class GetWorkingTimeSettingParam {
  final int? workingTimeTypeId;
  final int? userId;
  final int? organizationId;
  final int? branchOfficeId;
  final int? departmentId;
  final int? teamId;
  final bool? status;
  final String? startDate;
  final String? endDate;

  GetWorkingTimeSettingParam({
    this.workingTimeTypeId,
    this.userId,
    this.organizationId,
    this.branchOfficeId,
    this.departmentId,
    this.teamId,
    this.status,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (workingTimeTypeId != null)
      data['working_time_type_id'] = workingTimeTypeId;
    if (userId != null) data['user_id'] = userId;
    if (organizationId != null) data['organization_id'] = organizationId;
    if (branchOfficeId != null) data['branch_office_id'] = branchOfficeId;
    if (departmentId != null) data['department_id'] = departmentId;
    if (teamId != null) data['team_id'] = teamId;
    if (status != null) data['status'] = status;
    if (userId != null) data['start_date'] = startDate;
    if (endDate != null) data['end_date'] = endDate;
    return data;
  }
}
