import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/reward_discipline_model.dart';
import 'package:firefly/data/model/team_model.dart';

class EditBonusArgument {
  final List<OrganizationModel>? organizationsList;
  final List<BranchOfficeModel>? branchList;
  final List<DepartmentModel>? departmentList;
  final List<TeamModel>? teamList;
  final OrganizationModel? selectedOrganization;
  final BranchOfficeModel? selectedBranch;
  final DepartmentModel? selectedDepartment;
  final TeamModel? selectedTeam;
  final bool isReward;
  final RewardOrDisciplineModel? rewardOrDisModel;

  EditBonusArgument({
    this.organizationsList,
    this.branchList,
    this.departmentList,
    this.teamList,
    this.selectedOrganization,
    this.selectedBranch,
    this.selectedDepartment,
    this.selectedTeam,
    required this.isReward,
    this.rewardOrDisModel,
  });
}
