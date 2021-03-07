import 'package:flutter/material.dart';

import '../../../../../app/appTheme.dart';

class ChatNotificationView extends StatelessWidget {
  
  final int badgeCount;

  const ChatNotificationView({
    @required this.badgeCount,
    Key key, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: AppColors.indicatorColor,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        child: Text(
          '$badgeCount',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12
          ),
        ),
      ),
    );
  }
}