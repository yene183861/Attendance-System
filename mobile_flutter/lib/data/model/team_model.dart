import 'package:equatable/equatable.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/user_model.dart';

class TeamModel extends Equatable {
  final int? id;
  final String? name;
  final int? departmentId;
  final UserModel? leader;
  final int numberEmployees;

  const TeamModel({
    this.id,
    this.departmentId,
    this.name,
    this.leader,
    this.numberEmployees = 0,
  });

  factory TeamModel.fromJson(JSON json) {
    return TeamModel(
      id: json['id'].integerValue,
      name: json['name'].stringValue,
      departmentId: json['department'].integerValue,
      leader: UserModel.fromJson(json['leader']),
      numberEmployees: json['number_employees'].integerValue,
    );
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['department'] = departmentId;
    data['number_employees'] = numberEmployees;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        name,
        departmentId,
        leader,
        numberEmployees,
      ];
}
