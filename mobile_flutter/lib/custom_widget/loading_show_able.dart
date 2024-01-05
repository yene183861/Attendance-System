import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../configs/resources/barrel_const.dart';
import '../utils/size_config.dart';
import 'custom_loading_indicator.dart';

class LoadingShowAble {
  static final LoadingShowAble _instance = LoadingShowAble.internal();

  factory LoadingShowAble() => _instance;

  LoadingShowAble.internal();

  static int referenceCount = 0;

  static void showLoading() {
    if (referenceCount == 0) {
      BotToast.showCustomLoading(
        clickClose: false,
        allowClick: false,
        backButtonBehavior: BackButtonBehavior.none,
        ignoreContentClick: true,
        animationDuration: const Duration(milliseconds: 200),
        animationReverseDuration: const Duration(milliseconds: 200),
        align: Alignment.center,
        backgroundColor: COLOR_CONST.mineShaft2.withOpacity(0.79),
        toastBuilder: (cancelFunc) {
          return CustomLoadingIndicator(
            color: COLOR_CONST.backgroundColor,
            radius: appDefaultPadding,
          );
        },
      );
    }
    referenceCount += 1;
  }

  static void hideLoading() {
    referenceCount -= 1;
    if (referenceCount == 0) {
      BotToast.closeAllLoading();
    }
  }

  static void forceHide() {
    referenceCount = 0;
    BotToast.closeAllLoading();
  }
}
