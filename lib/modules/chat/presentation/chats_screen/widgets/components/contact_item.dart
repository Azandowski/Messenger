import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/circular_button_outlined.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/gradient_main_button.dart';
import 'package:messenger_mobile/core/widgets/independent/images/ImageWithCorner.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';

class ContactItemMessage extends StatelessWidget {
  final MessageUser messageUser;
  final bool isMyMessage;
  final Function () onTapOpenChat;

  ContactItemMessage({
    @required this.messageUser, 
    @required this.isMyMessage,
    @required this.onTapOpenChat
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              AvatarImage(
                isFromAsset: false,
                path: messageUser.avatarURL,
                width: 35, height: 35,
                borderRadius: BorderRadius.circular(17.5)
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    messageUser.name ?? '',
                    style: AppFontStyles.black14w400.copyWith(
                      color: isMyMessage ? Colors.white : Colors.black
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    messageUser.phone ?? '',
                    style: TextStyle(
                      color: isMyMessage ? Colors.white70: Colors.black54
                    )
                  ),
                ],
              )
            ]
          ),
          SizedBox(height: 8),
          CircularButtonOutlined(
            text: 'Написать'.toUpperCase(),
            borderColor: isMyMessage ? Colors.white : AppColors.indicatorColor,
            textStyle: AppFontStyles.white12w400.copyWith(
              color: isMyMessage ? Colors.white : AppColors.indicatorColor
            ),
            onTap: onTapOpenChat
          )
        ]
      )
    );
  }
}