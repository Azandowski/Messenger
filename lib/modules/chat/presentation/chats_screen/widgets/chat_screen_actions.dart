
import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';

class ChatScreenActions extends StatelessWidget {
  const ChatScreenActions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.video_call, 
            color: AppColors.indicatorColor,
          ), 
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.call,
            color: AppColors.indicatorColor,
          ),
          onPressed: () {
          
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert_rounded,
            color: AppColors.indicatorColor,
          ),
          onPressed: () {},
        )
      ],
    );
  }
}


