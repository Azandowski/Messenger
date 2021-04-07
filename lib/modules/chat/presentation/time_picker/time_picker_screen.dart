import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/widgets/independent/buttons/bottom_action_button.dart';
import '../chat_details/widgets/divider_wrapper.dart';
import 'widgets/option_view.dart';


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
        title: Text('deletion_timer'.tr()),
      ),
      body: SafeArea(
        child: Container(
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
                title: 'save'.tr(),
                onTap: () {
                  widget.delegate.didSelectTimeOption(currentOption);
                  Navigator.of(context).pop();
                }, 
              )
            ],
          ),
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
        return 'off'.tr();
      case TimeOptions.oneMinute:
        return 'one_minute'.tr();
      case TimeOptions.tenMinutes:
        return '10_minutes'.tr();
      case TimeOptions.thirtyMinutes:
        return '30_minutes'.tr();
      case TimeOptions.oneHour:
        return '1_hour'.tr();
      case TimeOptions.oneDay:
        return '1_day'.tr();
      case TimeOptions.oneWeek:
        return '1_week'.tr();
    }
  }

  num get seconds {
    switch (this) {
      case TimeOptions.off:
        return null;
      case TimeOptions.oneMinute:
        return 60;
      case TimeOptions.tenMinutes:
        return 600;
      case TimeOptions.thirtyMinutes:
        return 1800;
      case TimeOptions.oneHour:
        return 3600;
      case TimeOptions.oneDay:
        return 86400;
      case TimeOptions.oneWeek:
        return 604800;
    }
  }
}