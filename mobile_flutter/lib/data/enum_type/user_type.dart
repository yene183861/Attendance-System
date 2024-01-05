import 'package:easy_localization/easy_localization.dart';

enum UserType {
  ADMIN,
  CEO,
  DIRECTOR,
  MANAGER,
  LEADER,
  STAFF,
}

extension UserTypeExtension on UserType {
  int get type {
    switch (this) {
      case UserType.ADMIN:
        return 0;
      case UserType.CEO:
        return 1;
      case UserType.DIRECTOR:
        return 2;
      case UserType.MANAGER:
        return 3;
      case UserType.LEADER:
        return 4;
      case UserType.STAFF:
        return 5;
      default:
        return 5;
    }
  }

  String get value {
    switch (this) {
      case UserType.ADMIN:
        return 'admin_system'.tr();
      case UserType.CEO:
        return 'ceo'.tr();
      case UserType.DIRECTOR:
        return 'director'.tr();
      case UserType.MANAGER:
        return 'manager'.tr();
      case UserType.LEADER:
        return 'leader'.tr();
      case UserType.STAFF:
        return 'staff'.tr();
      default:
        return '';
    }
  }
}

class UserTypeHelper {
  static UserType convertType(int type) {
    switch (type) {
      case 0:
        return UserType.ADMIN;
      case 1:
        return UserType.CEO;
      case 2:
        return UserType.DIRECTOR;
      case 3:
        return UserType.MANAGER;
      case 4:
        return UserType.LEADER;
      default:
        return UserType.STAFF;
    }
  }
}
