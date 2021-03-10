import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';

class MessageCell extends StatelessWidget {
  final Message message;

  const MessageCell({
    Key key, 
    @required this.message
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var isMine = sl<AuthConfig>().user.id == message.user.id;
    var cellDecoration = BoxDecoration(
      color: !isMine ? Colors.white : (isMine && message.messageStatus == MessageStatus.sending) ? AppColors.greyColor :   AppColors.messageBlueBackground ,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(!isMine ? 0 : 10),
        bottomRight: Radius.circular(isMine ? 0 : 10),
        topRight: Radius.circular(10),
      ),
      border: Border.all(color: AppColors.indicatorColor)
    );
    
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          LimitedBox(
            maxWidth: w * 0.8,
            child: Container(
            padding: EdgeInsets.all(8),
            decoration: cellDecoration,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: isMine ?  CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (!isMine) 
                        Text(
                          message.user.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            color: Colors.blue,
                          ),
                          textAlign: TextAlign.left,
                        ),

                      if (isMine) Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.check, 
                            color: message.isRead ? AppColors.successGreenColor : AppColors.greyColor
                          ),
                      ),

                      Text(
                        '10:02',
                        style: isMine ? AppFontStyles.white12w400 : AppFontStyles.grey12w400, 
                        textAlign: TextAlign.right
                      )
                    ],
                    mainAxisSize: isMine ? MainAxisSize.min : MainAxisSize.min,
                    mainAxisAlignment: !isMine ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceBetween,
                  ),
                  if (message.text != null) 
                    Text(
                      message.text, 
                      style: !isMine ? AppFontStyles.black14w400 : AppFontStyles.white14w400,
                      textAlign: TextAlign.left,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}