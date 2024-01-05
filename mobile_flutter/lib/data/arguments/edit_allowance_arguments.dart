import 'package:firefly/data/model/allowance_model.dart';

class EditAllowanceArgument {
  int idOrganization;
  AllowanceModel? allowanceModel;

  EditAllowanceArgument({
    required this.idOrganization,
    this.allowanceModel,
  });
}
