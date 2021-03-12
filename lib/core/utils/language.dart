import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum ApplicationLanguage { kazakh, russian, english, chinese, turkish }

extension ApplicationLanguageExtension on ApplicationLanguage {
  String get name {
    switch (this) {
      case ApplicationLanguage.kazakh:
        return 'Қазақ';
      case ApplicationLanguage.russian:
        return 'Русский';
      case ApplicationLanguage.english:
        return 'English';
      case ApplicationLanguage.chinese:
        return '中文';
      case ApplicationLanguage.turkish:
        return "Türk";
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
      case ApplicationLanguage.chinese:
        return Locale('zh', 'CN');
      case ApplicationLanguage.turkish:
        return Locale('tr', 'TR');
    }
  }
}
