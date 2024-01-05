import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/user_work_model.dart';

import '../model/user_model.dart';

class LoginResponseModel {
  String token;
  UserModel user;
  UserWorkModel? userWork;

  LoginResponseModel({
    required this.token,
    required this.user,
    this.userWork,
  });

  factory LoginResponseModel.fromJson(JSON json) {
    return LoginResponseModel(
      token: json['token'].stringValue,
      user: UserModel.fromJson(json['profile']),
      userWork: UserWorkModel.fromJson(json['work']),
    );
  }
}
