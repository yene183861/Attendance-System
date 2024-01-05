import 'package:easy_localization/easy_localization.dart';

enum ByTime {
  MINUTE,
  HOUR,
  DAY,
  WEEK,
  MONTH,
  YEAR,
  ONE_TIME,
}

extension ByTimeExtension on ByTime {
  int get type {
    switch (this) {
      case ByTime.MINUTE:
        return 0;
      case ByTime.HOUR:
        return 1;
      case ByTime.DAY:
        return 2;
      case ByTime.WEEK:
        return 3;
      case ByTime.MONTH:
        return 4;
      case ByTime.YEAR:
        return 5;
      case ByTime.ONE_TIME:
        return 6;
      default:
        return 0;
    }
  }

  String get value {
    switch (this) {
      case ByTime.MINUTE:
        return 'msg_minute'.tr();
      case ByTime.HOUR:
        return 'msg_hour'.tr();
      case ByTime.DAY:
        return 'msg_day'.tr();
      case ByTime.WEEK:
        return 'msg_week'.tr();
      case ByTime.MONTH:
        return 'msg_month'.tr();
      case ByTime.YEAR:
        return 'msg_year'.tr();
      case ByTime.ONE_TIME:
        return 'one_time'.tr();
      default:
        return '';
    }
  }
}

class ByTimeHelper {
  static ByTime convertType(int type) {
    switch (type) {
      case 0:
        return ByTime.MINUTE;
      case 1:
        return ByTime.HOUR;
      case 2:
        return ByTime.DAY;
      case 3:
        return ByTime.WEEK;
      case 4:
        return ByTime.MONTH;
      case 5:
        return ByTime.YEAR;
      case 6:
        return ByTime.ONE_TIME;
      default:
        return ByTime.MINUTE;
    }
  }
}
