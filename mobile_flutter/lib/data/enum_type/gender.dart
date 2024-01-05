import 'package:easy_localization/easy_localization.dart';

enum Gender {
  FEMALE,
  MALE,
}

extension GenderExtension on Gender {
  int get type {
    switch (this) {
      case Gender.MALE:
        return 0;
      case Gender.FEMALE:
        return 1;
      default:
        return 0;
    }
  }

  String get value {
    switch (this) {
      case Gender.MALE:
        return 'male'.tr();
      case Gender.FEMALE:
        return 'female'.tr();
      default:
        return '';
    }
  }
}

class GenderHelper {
  static Gender convertType(int type) {
    if (type == Gender.MALE.type) {
      return Gender.MALE;
    } else if (type == Gender.FEMALE.type) {
      return Gender.FEMALE;
    }
    return Gender.MALE;
  }
}
