import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_view_model.dart';
class NameTimeBloc extends StatelessWidget {
  final MessageViewModel messageViewModel;

  const NameTimeBloc({Key key, @required this.messageViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!messageViewModel.isMine) 
          Text(
            messageViewModel.userNameText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: messageViewModel.color,
            ),
            textAlign: TextAlign.left,
          ),

        if (messageViewModel.isMine) 
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Image.asset(
              messageViewModel.readImageName, width: 20, height: 8
            )
          ),

        Text(
          messageViewModel.time,
          style: messageViewModel.isMine ? 
            AppFontStyles.whiteGrey12w400 : AppFontStyles.grey12w400, 
          textAlign: TextAlign.right
        )
      ],
      mainAxisSize:  MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}