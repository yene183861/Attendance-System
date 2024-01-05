import 'package:firefly/data/enum_type/gender.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/user_work_model.dart';

class CreateUserModel {
  final String email;
  final String fullName;
  final Gender gender;
  final UserType userType;
  final UserWorkModel? userWork;

  CreateUserModel({
    required this.email,
    required this.fullName,
    required this.userType,
    this.gender = Gender.MALE,
    this.userWork,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['email'] = email;
    data['full_name'] = fullName;
    data['gender'] = gender.type;
    data['user_type'] = userType.type;
    data['user_work'] = userWork?.toJson();

    return data;
  }
}
