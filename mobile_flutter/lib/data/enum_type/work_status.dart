import 'package:easy_localization/easy_localization.dart';

enum WorkStatus {
  POSTPONING_WORK,
  WORKING,
  LEAVED,
}

extension WorkStatusExtension on WorkStatus {
  int get type {
    switch (this) {
      case WorkStatus.POSTPONING_WORK:
        return 0;
      case WorkStatus.WORKING:
        return 1;
      case WorkStatus.LEAVED:
        return 2;
      default:
        return 0;
    }
  }

  String get value {
    switch (this) {
      case WorkStatus.POSTPONING_WORK:
        return 'status_postponing_work'.tr();
      case WorkStatus.WORKING:
        return 'status_working'.tr();
      case WorkStatus.LEAVED:
        return 'status_leaved'.tr();
      default:
        return '';
    }
  }
}

class WorkStatusHelper {
  static WorkStatus convertType(int type) {
    switch (type) {
      case 0:
        return WorkStatus.POSTPONING_WORK;
      case 1:
        return WorkStatus.WORKING;
      case 2:
        return WorkStatus.LEAVED;
      default:
        return WorkStatus.POSTPONING_WORK;
    }
  }
}
