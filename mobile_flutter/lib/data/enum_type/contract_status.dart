import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum ContractStatus {
  INVALID_CONTRACT,
  VALID_CONTRACT,
  EXPIRED_CONTRACT,
  LIQUIDATION_CONTRACT,
}

extension ContractStatusExtension on ContractStatus {
  int get type {
    switch (this) {
      case ContractStatus.INVALID_CONTRACT:
        return 0;
      case ContractStatus.VALID_CONTRACT:
        return 1;
      case ContractStatus.EXPIRED_CONTRACT:
        return 2;
      case ContractStatus.LIQUIDATION_CONTRACT:
        return 3;
      default:
        return 1;
    }
  }

  String get value {
    switch (this) {
      case ContractStatus.INVALID_CONTRACT:
        return 'Chưa có hiệu lực'.tr();
      case ContractStatus.VALID_CONTRACT:
        return 'Đang có hiệu lực'.tr();
      case ContractStatus.EXPIRED_CONTRACT:
        return 'Hết hạn'.tr();
      case ContractStatus.LIQUIDATION_CONTRACT:
        return 'Đã thanh lý'.tr();
      default:
        return '';
    }
  }

  Color get color {
    switch (this) {
      case ContractStatus.INVALID_CONTRACT:
        return Colors.blue.withOpacity(0.8);
      case ContractStatus.VALID_CONTRACT:
        return Colors.green.withOpacity(0.8);
      case ContractStatus.EXPIRED_CONTRACT:
        return Colors.red.withOpacity(0.8);
      case ContractStatus.LIQUIDATION_CONTRACT:
        return Colors.grey.withOpacity(0.8);
      default:
        return Colors.green.withOpacity(0.8);
    }
  }
}

class ContractStatusHelper {
  static ContractStatus convertType(int type) {
    switch (type) {
      case 0:
        return ContractStatus.INVALID_CONTRACT;
      case 1:
        return ContractStatus.VALID_CONTRACT;
      case 2:
        return ContractStatus.EXPIRED_CONTRACT;
      case 3:
        return ContractStatus.LIQUIDATION_CONTRACT;
      default:
        return ContractStatus.INVALID_CONTRACT;
    }
  }
}
