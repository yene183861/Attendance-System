import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/team_model.dart';

class CreateUserArgument {
  OrganizationModel? organization;
  BranchOfficeModel? branch;
  DepartmentModel? department;
  TeamModel? team;

  CreateUserArgument({
    this.organization,
    this.branch,
    this.department,
    this.team,
  });
}
