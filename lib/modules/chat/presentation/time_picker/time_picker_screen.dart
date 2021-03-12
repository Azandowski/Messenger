import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/bottom_action_button.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/divider_wrapper.dart';
import 'package:messenger_mobile/modules/chat/presentation/time_picker/widgets/option_view.dart';


abstract class TimePickerDelegate {
  void didSelectTimeOption (TimeOptions option);
}


class TimePickerScreen extends StatefulWidget {

  static Route route(TimePickerDelegate timePickerDelegate) {
    return MaterialPageRoute<void>(builder: (_) => TimePickerScreen(timePickerDelegate));
  }

  final TimePickerDelegate delegate;

  TimePickerScreen(this.delegate);
 
  @override
  _TimePickerScreenState createState() => _TimePickerScreenState();
}

class _TimePickerScreenState extends State<TimePickerScreen> {
  
  TimeOptions currentOption = TimeOptions.off;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Таймер сгорания'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 50),
              child: SingleChildScrollView(
                child: DividerWrapper(
                  children: TimeOptions.values.map(
                    (e) => OptionView(
                      isSelected: e.index == currentOption.index,
                      text: e.title,
                      onPressed: () {
                        setState(() {
                          currentOption = e;
                        });
                      }
                    )
                  ).toList()
                ),
              ),
            ),
            BottomActionButtonContainer(
              title: 'Сохранить',
              onTap: () {
                widget.delegate.didSelectTimeOption(currentOption);
                Navigator.of(context).pop();
              }, 
            )
          ],
        ),
      )
    );
  }
}


enum TimeOptions {
  off, oneMinute, tenMinutes, thirtyMinutes, oneHour, oneDay, oneWeek
}

extension TimeRangesUIExtension on TimeOptions {
  String get title {
    switch (this) {
      case TimeOptions.off:
        return 'Выкл';
      case TimeOptions.oneMinute:
        return '1 минуту';
      case TimeOptions.tenMinutes:
        return '10 минут';
      case TimeOptions.thirtyMinutes:
        return '30 минут';
      case TimeOptions.oneHour:
        return '1 час';
      case TimeOptions.oneDay:
        return '1 день';
      case TimeOptions.oneWeek:
        return '1 неделя';
    }
  }
}