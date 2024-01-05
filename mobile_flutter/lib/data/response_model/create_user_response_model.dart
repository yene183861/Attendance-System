import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/user_work_model.dart';

import '../model/user_model.dart';

class CreateUserResponseModel {
  UserModel user;
  UserWorkModel? userWork;

  CreateUserResponseModel({
    required this.user,
    this.userWork,
  });

  factory CreateUserResponseModel.fromJson(JSON json) {
    return CreateUserResponseModel(
      user: UserModel.fromJson(json['user']),
      userWork: UserWorkModel.fromJson(json['work']),
    );
  }
}
