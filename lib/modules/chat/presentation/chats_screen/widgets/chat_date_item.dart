import 'package:flutter/material.dart';

import '../../../../../core/utils/date_helper.dart';
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
      margin: const EdgeInsets.only(top: 8),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        child: Text(
          sl<DateHelper>().getChatDay(dateTime)
        )
      )
    );
  }
}