import 'package:firefly/data/model/branch_office_model.dart';

class EditBranchArgument {
  int idOrganization;
  BranchOfficeModel? branchModel;

  EditBranchArgument({
    required this.idOrganization,
    this.branchModel,
  });
}
