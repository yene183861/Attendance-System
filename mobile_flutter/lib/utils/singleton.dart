import 'package:flutter/cupertino.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/user_work_model.dart';

import '../data/model/user_model.dart';

class Singleton {
  static final Singleton _appConfig = Singleton._internal();
  static Singleton get instance => _appConfig;
  factory Singleton() {
    return _appConfig;
  }
  Singleton._internal();

  String? tokenLogin;
  UserModel? userProfile;
  UserWorkModel? userWork;
  UserType? userType;

  bool isStatusInternet = true;
  String converstionId = "";
  bool isVerificationUser = false;
  bool isAllowShowReview = true;
  UniqueKey keyFormDaborad = UniqueKey();
  String currentLanguageCode = "vi";

  bool get isLoginUser {
    return tokenLogin != null;
  }
}
