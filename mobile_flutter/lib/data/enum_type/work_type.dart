import 'package:easy_localization/easy_localization.dart';

enum WorkType {
  DAILY_WORK,
  OVERTIME_DAILY_WORK,
  WORK_DAY_OFF,
  OVERTIME_DAY_OFF,
  WORK_HOLIDAY,
  OVERTIME_HOLIDAY,
}

extension WorkTypeExtension on WorkType {
  int get type {
    switch (this) {
      case WorkType.DAILY_WORK:
        return 0;
      case WorkType.OVERTIME_DAILY_WORK:
        return 1;
      case WorkType.WORK_DAY_OFF:
        return 2;
      case WorkType.OVERTIME_DAY_OFF:
        return 3;
      case WorkType.WORK_HOLIDAY:
        return 4;
      case WorkType.OVERTIME_HOLIDAY:
        return 5;
      default:
        return 0;
    }
  }

  String get value {
    switch (this) {
      case WorkType.DAILY_WORK:
        return 'msg_daily_work'.tr();
      case WorkType.OVERTIME_DAILY_WORK:
        return 'msg_overtime_daily_work'.tr();
      case WorkType.WORK_DAY_OFF:
        return 'msg_day_off'.tr();
      case WorkType.OVERTIME_DAY_OFF:
        return 'msg_overtime_day_off'.tr();
      case WorkType.WORK_HOLIDAY:
        return 'msg_work_holiday'.tr();
      case WorkType.OVERTIME_HOLIDAY:
        return 'msg_overtime_holiday'.tr();
      default:
        return '';
    }
  }

  double get work {
    switch (this) {
      case WorkType.DAILY_WORK:
        return 1.0;
      case WorkType.OVERTIME_DAILY_WORK:
        return 1.5;
      case WorkType.WORK_DAY_OFF:
        return 2.0;
      case WorkType.OVERTIME_DAY_OFF:
        return 2.5;
      case WorkType.WORK_HOLIDAY:
        return 3.0;
      case WorkType.OVERTIME_HOLIDAY:
        return 3.5;
      default:
        return 0.0;
    }
  }
}

class WorkTypeHelper {
  static WorkType convertType(int type) {
    switch (type) {
      case 0:
        return WorkType.DAILY_WORK;
      case 1:
        return WorkType.OVERTIME_DAILY_WORK;
      case 2:
        return WorkType.WORK_DAY_OFF;
      case 3:
        return WorkType.OVERTIME_DAY_OFF;
      case 4:
        return WorkType.WORK_HOLIDAY;
      case 5:
        return WorkType.OVERTIME_HOLIDAY;
      default:
        return WorkType.DAILY_WORK;
    }
  }
}
