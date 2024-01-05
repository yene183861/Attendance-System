import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum ContractType {
  SEASONAL_CONTRACT,
  FIXED_TERM_LABOR_CONTRACT,
  INDEFINITE_TERM_LABOR_CONTRACT,
}

extension ContractTypeExtension on ContractType {
  int get type {
    switch (this) {
      case ContractType.SEASONAL_CONTRACT:
        return 0;
      case ContractType.FIXED_TERM_LABOR_CONTRACT:
        return 1;
      case ContractType.INDEFINITE_TERM_LABOR_CONTRACT:
        return 2;
      default:
        return 0;
    }
  }

  String get value {
    switch (this) {
      case ContractType.SEASONAL_CONTRACT:
        return 'Hợp đồng thời vụ'.tr();
      case ContractType.FIXED_TERM_LABOR_CONTRACT:
        return 'Hợp đồng có thời hạn'.tr();
      case ContractType.INDEFINITE_TERM_LABOR_CONTRACT:
        return 'Hợp đồng vô thời hạn'.tr();
      default:
        return '';
    }
  }

  Color get color {
    switch (this) {
      case ContractType.SEASONAL_CONTRACT:
        return Colors.amber.withOpacity(0.8);
      case ContractType.FIXED_TERM_LABOR_CONTRACT:
        return Colors.green.withOpacity(0.8);
      case ContractType.INDEFINITE_TERM_LABOR_CONTRACT:
        return Colors.red.withOpacity(0.8);
      default:
        return Colors.amber.withOpacity(0.8);
    }
  }
}

class ContractTypeHelper {
  static ContractType convertType(int type) {
    switch (type) {
      case 0:
        return ContractType.SEASONAL_CONTRACT;
      case 1:
        return ContractType.FIXED_TERM_LABOR_CONTRACT;
      case 2:
        return ContractType.INDEFINITE_TERM_LABOR_CONTRACT;
      default:
        return ContractType.SEASONAL_CONTRACT;
    }
  }
}
