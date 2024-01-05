import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:firefly/configs/resources/color_const.dart';

const appDefaultGradient = LinearGradient(
  colors: [COLOR_CONST.purpleHeart, COLOR_CONST.jaffa],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class Utils {
  static String formatDateTimeToString(
      {required DateTime time, required DateFormat dateFormat}) {
    return dateFormat.format(time);
  }

  // static Future<void> cleanAllToken() async {
  //   final keyLanguage = await SessionManager.share.getKeyLanguageSave();
  //   DioProvider.getCacheManager().clearAll();
  //   Singleton.instance.tokenLogin = null;
  //   await FirebaseMessaging.instance.deleteToken();
  //   await SessionManager.share.removeToken();
  //   await SessionManager.share.removeFirebaseToken();
  //   await SessionManager.share.removeProfile();
  //   // await SessionManager.share.removeOrganization();
  //   // await SessionManager.share.removeBranchOffice();
  //   await SessionManager.share.removeAll();
  //   await SessionManager.share.saveIsFirstOpenApp();
  //   // if (keyLanguage != null) {
  //   //   await SessionManager.share.saveKeyLanguageSave(keyLanguage);
  //   // }
  // }

  static String roundStringDateTime({required String time}) {
    final timeSplit = time.split(':');
    final hour = int.parse(timeSplit[0]);
    final minute = int.parse(timeSplit[1]);
    if (minute == 0 || minute % 30 == 0) return time;

    final roundMinute = (30 - (minute % 30)) + minute;
    if (roundMinute == 60) return convertTime(hour + 1, 0);
    return convertTime(hour, roundMinute);
  }

  static String convertTime(int hour, int minute) {
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  static String formatCurrency(
      {required double amount,
      required String format,
      String? locale,
      required BuildContext context}) {
    return NumberFormat(format, locale ?? context.locale.languageCode)
        .format(amount);
  }

  static List<String> generateTimeList() {
    List<String> timeList = [];
    for (int hour = 8; hour < 22; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        String formattedHour = hour.toString().padLeft(2, '0');
        String formattedMinute = minute.toString().padLeft(2, '0');
        String timeString = '$formattedHour:$formattedMinute';
        timeList.add(timeString);
      }
    }
    return timeList;
  }

  static DateTime floorToNearest30Minutes(DateTime dateTime) {
    int minute = dateTime.minute;

    int remainder = minute % 30;

    if (remainder == 0) {
      return dateTime;
    }

    int minutesToAdd = 30 - remainder;

    DateTime roundedDateTime = dateTime.add(Duration(minutes: minutesToAdd));

    return roundedDateTime;
  }
}
