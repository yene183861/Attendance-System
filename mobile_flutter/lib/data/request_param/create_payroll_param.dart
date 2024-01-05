import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/utils.dart';

class CreatePayrollParam {
  final int userId;
  final DateTime month;

  CreatePayrollParam({
    required this.userId,
    required this.month,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['user_id'] = userId;
    data['month'] = Utils.formatDateTimeToString(
        time: month, dateFormat: DateFormat(DateTimePattern.dayType2));
    return data;
  }
}
