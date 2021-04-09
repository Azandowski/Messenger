import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:messenger_mobile/app/application.dart';
import 'package:messenger_mobile/core/config/language.dart';
import '../../locator.dart';

extension DateExtension on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == this.day &&
          now.month == this.month &&
          now.year == this.year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.day == this.day &&
      yesterday.month == this.month &&
      yesterday.year == this.year;
  }

  bool isThisYear () {
    final now = DateTime.now();
    return now.year == this.year;
  }
}


class DateHelper {
  String getLastOnlineDate (DateTime dateTime) {
    var locale = sl<Application>().appLanguage.localeKey;

    if (dateTime.isToday()) {
      return 'was_at'.tr(namedArgs: {
        'date': DateFormat.Hm(locale).format(dateTime)
      });
    } else if (dateTime.isYesterday()) {
      return 'was_yesterday_at'.tr(namedArgs: {
        'date': DateFormat.Hm(locale).format(dateTime)
      });
    } else if (dateTime.isThisYear()) {
      return 'was_at'.tr(namedArgs: {
        'date': DateFormat.MMMMd(locale).format(dateTime)
      });
    } else {
      return 'was_at'.tr(namedArgs: {
        'date': DateFormat.yMMMMd(locale).format(dateTime)
      });
    }
  }


  String getTimerLeft (int timeInSeconds) {
    var locale = sl<Application>().appLanguage.localeKey;
    if (timeInSeconds <= 24 * 60 * 60) {
      return _formatDuration(Duration(seconds: timeInSeconds));
    } else {
      return (timeInSeconds / (24 * 60 * 60)).toStringAsFixed(0) + 'd';
    }
  }

  String getChatDay (DateTime dateTime) {
    if (dateTime.isToday()) { 
      return 'today'.tr();
    } else if (dateTime.isYesterday()) {
      return 'yesterday'.tr();
    } else if (dateTime.isThisYear()) { 
      return DateFormat.MMMMd('ru-RU').format(dateTime);
    } else {
      return DateFormat.yMMMMd('ru-RU').format(dateTime);
    }
  } 


  String _formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds~/Duration.secondsPerDay;
    seconds -= days*Duration.secondsPerDay;
    final hours = seconds~/Duration.secondsPerHour;
    seconds -= hours*Duration.secondsPerHour;
    final minutes = seconds~/Duration.secondsPerMinute;
    seconds -= minutes*Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0){
      tokens.add('${hours}h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}m');
    }
    tokens.add('${seconds}s');

    return tokens.join(':');
  }
}
