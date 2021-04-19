import 'package:flutter/material.dart';

enum ApplicationLanguage { kazakh, russian, english }
//chinese, turkish

extension ApplicationLanguageExtension on ApplicationLanguage {
  String get name {
    switch (this) {
      case ApplicationLanguage.kazakh:
        return 'Қазақ';
      case ApplicationLanguage.russian:
        return 'Русский';
      case ApplicationLanguage.english:
        return 'English';
      // case ApplicationLanguage.chinese:
      //   return '中文';
      // case ApplicationLanguage.turkish:
      //   return "Türk";
    }
  }

  Locale get localeCode {
    switch (this) {
      case ApplicationLanguage.kazakh:
        return Locale('kk', 'KZ');
      case ApplicationLanguage.russian:
        return Locale('ru', 'RU');
      case ApplicationLanguage.english:
        return Locale('en', 'US');
      // case ApplicationLanguage.chinese:
      //   return Locale('zh', 'CN');
      // case ApplicationLanguage.turkish:
      //   return Locale('tr', 'TR');
    }
  }

  String get yandexTrKey {
    switch (this) {
      case ApplicationLanguage.kazakh:
        return 'kk';
      case ApplicationLanguage.russian:
        return 'ru';
      case ApplicationLanguage.english:
        return 'en';
      // case ApplicationLanguage.chinese:
      //   return 'zh';
      // case ApplicationLanguage.turkish:
      //   return "tr";
      default:
        return '';
    }
  }

  String get localeKey {
    switch (this) {
      case ApplicationLanguage.kazakh:
        return 'kk-KZ';
      case ApplicationLanguage.russian:
        return 'ru-RU';
      case ApplicationLanguage.english:
        return 'en-US';
      // case ApplicationLanguage.chinese:
      //   return 'zh-CN';
      // case ApplicationLanguage.turkish:
      //   return "tr-TR";
      default:
        return '';
    }
  }
}