import 'package:firefly/data/model/contract_model.dart';

import 'package:firefly/data/model/user_work_model.dart';

class EditContractArgument {
  final ContractModel? contractModel;
  final UserWorkModel? selectedUser;

  EditContractArgument({
    this.contractModel,
    this.selectedUser,
  });
}
