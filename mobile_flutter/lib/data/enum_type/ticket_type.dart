import 'package:easy_localization/easy_localization.dart';

enum TicketType {
  APPLICATION_FOR_THOUGHT,
  ABSENCE_APPLICATION,
  APPLICATION_FOR_OVERTIME,
  CHECK_IN_OUT_FORM,
}

extension TicketTypeExtension on TicketType {
  int get type {
    switch (this) {
      case TicketType.APPLICATION_FOR_THOUGHT:
        return 0;
      case TicketType.ABSENCE_APPLICATION:
        return 1;
      case TicketType.APPLICATION_FOR_OVERTIME:
        return 2;
      case TicketType.CHECK_IN_OUT_FORM:
        return 3;
      default:
        return 0;
    }
  }

  String get value {
    switch (this) {
      case TicketType.APPLICATION_FOR_THOUGHT:
        return 'ticket_application_for_thought'.tr();
      case TicketType.ABSENCE_APPLICATION:
        return 'ticket_absence_application'.tr();
      case TicketType.APPLICATION_FOR_OVERTIME:
        return 'ticket_application_for_overtime'.tr();
      case TicketType.CHECK_IN_OUT_FORM:
        return 'ticket_check_in_out_form'.tr();
      default:
        return '';
    }
  }
}

class TicketTypeHelper {
  static TicketType convertType(int type) {
    switch (type) {
      case 0:
        return TicketType.APPLICATION_FOR_THOUGHT;
      case 1:
        return TicketType.ABSENCE_APPLICATION;
      case 2:
        return TicketType.APPLICATION_FOR_OVERTIME;
      case 3:
        return TicketType.CHECK_IN_OUT_FORM;
      default:
        return TicketType.APPLICATION_FOR_THOUGHT;
    }
  }
}
