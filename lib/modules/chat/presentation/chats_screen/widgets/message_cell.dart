import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_view_model.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';

class MessageCell extends StatelessWidget {
  final MessageViewModel messageViewModel;
  final int nextMessageUserID;
  final int prevMessageUserID;

  const MessageCell({
    @required this.messageViewModel,
    this.nextMessageUserID,
    this.prevMessageUserID,
    Key key, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: messageViewModel.isMine ?
          MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          LimitedBox(
            maxWidth: w * 0.8,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: messageViewModel.getCellDecoration(
                previousMessageUserID: prevMessageUserID, 
                nextMessageUserID: nextMessageUserID
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: messageViewModel.isMine ? 
                  CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Row(
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
                  ),

                  if (messageViewModel.messageText != null) 
                    Text(
                      messageViewModel.messageText, 
                      style: !messageViewModel.isMine ? 
                        AppFontStyles.black14w400 : AppFontStyles.white14w400,
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

