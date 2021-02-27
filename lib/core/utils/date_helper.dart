import 'package:intl/intl.dart';


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
    if (dateTime.isToday()) {
      return 'Был(а) в ' + DateFormat.Hm('ru-RU').format(dateTime);
    } else if (dateTime.isYesterday()) {
      return 'Был(а) Вчера в ' + DateFormat.Hm('ru-RU').format(dateTime);
    } else if (dateTime.isThisYear()) {
      return 'Был(а) ' + DateFormat.MMMMd('ru-RU').format(dateTime);
    } else {
      return 'Был(а) ' + DateFormat.yMMMMd('ru-RU').format(dateTime);
    }
  }
}
