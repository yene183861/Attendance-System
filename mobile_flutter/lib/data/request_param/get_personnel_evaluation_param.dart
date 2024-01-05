class GetPersonnelEvaluationParam {
  final String? month;
  final int? userId;
  final int? organizationId;
  final int? branchOfficeId;
  final int? departmentId;
  final int? teamId;
  final bool? status;

  GetPersonnelEvaluationParam({
    this.month,
    this.userId,
    this.organizationId,
    this.branchOfficeId,
    this.departmentId,
    this.teamId,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (month != null) data['month'] = month;
    if (userId != null) data['user_id'] = userId;
    if (organizationId != null) data['organization_id'] = organizationId;
    if (branchOfficeId != null) data['branch_office_id'] = branchOfficeId;
    if (departmentId != null) data['department_id'] = departmentId;
    if (teamId != null) data['team_id'] = teamId;
    if (status != null) data['status'] = status;
    return data;
  }
}
