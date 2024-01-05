class CommonParam {
  final int? userId;
  final int? organizationId;
  final int? branchOfficeId;
  final int? departmentId;
  final int? teamId;

  CommonParam({
    this.userId,
    this.organizationId,
    this.branchOfficeId,
    this.departmentId,
    this.teamId,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (userId != null) data['user_id'] = userId;
    if (organizationId != null) data['organization_id'] = organizationId;
    if (branchOfficeId != null) data['branch_office_id'] = branchOfficeId;
    if (departmentId != null) data['department_id'] = departmentId;
    if (teamId != null) data['team_id'] = teamId;
    return data;
  }
}
