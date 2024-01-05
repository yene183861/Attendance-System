import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum TicketStatus {
  PENDING,
  APPROVED,
  REFUSE,
}

extension TicketStatusExtension on TicketStatus {
  int get type {
    switch (this) {
      case TicketStatus.PENDING:
        return 0;
      case TicketStatus.APPROVED:
        return 1;
      case TicketStatus.REFUSE:
        return 2;
      default:
        return 0;
    }
  }

  String get value {
    switch (this) {
      case TicketStatus.PENDING:
        return 'status_pending'.tr();
      case TicketStatus.APPROVED:
        return 'status_approved'.tr();
      case TicketStatus.REFUSE:
        return 'status_refuse'.tr();
      default:
        return '';
    }
  }

  Color get color {
    switch (this) {
      case TicketStatus.PENDING:
        return Colors.amber;
      case TicketStatus.APPROVED:
        return Colors.green;
      case TicketStatus.REFUSE:
        return Color.fromRGBO(168, 18, 18, 1);
      default:
        return Colors.amber;
    }
  }
}

class TicketStatusHelper {
  static TicketStatus convertType(int type) {
    switch (type) {
      case 0:
        return TicketStatus.PENDING;
      case 1:
        return TicketStatus.APPROVED;
      case 2:
        return TicketStatus.REFUSE;
      default:
        return TicketStatus.PENDING;
    }
  }
}
