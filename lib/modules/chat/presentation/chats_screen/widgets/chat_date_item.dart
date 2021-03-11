import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/utils/date_helper.dart';

import '../../../../../locator.dart';

class ChatDateItem extends StatelessWidget {
  
  final DateTime dateTime;
  
  const ChatDateItem({
    @required this.dateTime,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      color: Colors.white,
      child: Center(
        child: Text(
          sl<DateHelper>().getChatDay(dateTime)
        )
      )
    );
  }
}