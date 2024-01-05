import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';

enum ToastMessageType {
  SUCCESS,
  ERROR,
  INFO,
}

extension ToastMessageTypeExtension on ToastMessageType {
  Color get color {
    switch (this) {
      case ToastMessageType.SUCCESS:
        return COLOR_CONST.cloudBurst;
      case ToastMessageType.ERROR:
        return COLOR_CONST.backgroundColor;
      case ToastMessageType.INFO:
        return COLOR_CONST.backgroundColor;
    }
  }

  String get icon {
    switch (this) {
      case ToastMessageType.SUCCESS:
        return ICON_CONST.icSuccess.path;
      case ToastMessageType.ERROR:
        return ICON_CONST.icFailure.path;
      case ToastMessageType.INFO:
        return ICON_CONST.icSuccess.path;
    }
  }

  Color get textColor {
    switch (this) {
      case ToastMessageType.SUCCESS:
        return COLOR_CONST.backgroundColor;
      case ToastMessageType.ERROR:
        return COLOR_CONST.carnation;
      case ToastMessageType.INFO:
        return COLOR_CONST.cloudBurst;
    }
  }
}
