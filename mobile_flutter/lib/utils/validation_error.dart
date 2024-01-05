import 'package:flutter/material.dart';

enum ValidationError { empty, invalid }

extension ValidationErrorX on ValidationError {
  Color get color {
    switch (this) {
      case ValidationError.empty:
        return Colors.yellow;
      case ValidationError.invalid:
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  bool get showErrorText {
    switch (this) {
      case ValidationError.empty:
        return false;
      case ValidationError.invalid:
        return true;
      default:
        return false;
    }
  }
}
