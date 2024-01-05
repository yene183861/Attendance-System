import 'package:equatable/equatable.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/user_model.dart';

class DepartmentModel extends Equatable {
  final int? id;
  final int? branchOfficeId;
  final String? name;
  final UserModel? manager;
  final int numberEmployees;

  const DepartmentModel({
    this.id,
    this.branchOfficeId,
    this.name,
    this.manager,
    this.numberEmployees = 0,
  });

  factory DepartmentModel.fromJson(JSON json) {
    return DepartmentModel(
      id: json['id'].integerValue,
      name: json['name'].stringValue,
      branchOfficeId: json['branch_office'].integerValue,
      manager: UserModel.fromJson(json['manager']),
      numberEmployees: json['number_employees'].integerValue,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['branch_office'] = branchOfficeId;
    data['number_employees'] = numberEmployees;

    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        name,
        branchOfficeId,
        manager,
        numberEmployees,
      ];
}
