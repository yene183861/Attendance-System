// ignore_for_file: constant_identifier_names

// import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:firefly/data/model/language_model.dart';

enum LanguageType {
  VIETNAM,
  ENGLISH,
  KOREAN,
  JAPAN,
}

extension LanguageTypeExtension on LanguageType {
  String get type {
    switch (this) {
      case LanguageType.VIETNAM:
        return "vi";
      case LanguageType.ENGLISH:
        return "en";
      case LanguageType.KOREAN:
        return "ko";
      case LanguageType.JAPAN:
        return "ja";
      default:
        return "";
    }
  }

  String get value {
    switch (this) {
      case LanguageType.VIETNAM:
        return 'title_language_vietnam'.tr();
      case LanguageType.ENGLISH:
        return 'title_language_english'.tr();
      case LanguageType.KOREAN:
        return 'title_language_korean'.tr();
      case LanguageType.JAPAN:
        return 'title_language_japan'.tr();
      default:
        return '';
    }
  }

  Locale get locale {
    switch (this) {
      case LanguageType.VIETNAM:
        return const Locale('vi');
      case LanguageType.ENGLISH:
        return const Locale('en');
      case LanguageType.KOREAN:
        return const Locale('ko');
      case LanguageType.JAPAN:
        return const Locale('ja');
      default:
        return const Locale(' ');
    }
  }
}

class LanguageHelper {
  List<LanguageModel> getAll() {
    return [
      LanguageModel(
          key: LanguageType.VIETNAM.type,
          title: LanguageType.VIETNAM.value,
          locale: LanguageType.VIETNAM.locale),
      LanguageModel(
          key: LanguageType.ENGLISH.type,
          title: LanguageType.ENGLISH.value,
          locale: LanguageType.ENGLISH.locale),
      LanguageModel(
          key: LanguageType.JAPAN.type,
          title: LanguageType.JAPAN.value,
          locale: LanguageType.JAPAN.locale),
      LanguageModel(
          key: LanguageType.KOREAN.type,
          title: LanguageType.KOREAN.value,
          locale: LanguageType.KOREAN.locale),
    ];
  }
}
