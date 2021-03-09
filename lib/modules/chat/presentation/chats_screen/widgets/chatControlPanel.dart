import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';

class ChatControlPanel extends StatelessWidget {
  const ChatControlPanel({
    Key key,
    @required this.messageTextController,
    @required this.width,
    @required this.height,
  }) : super(key: key);

  final TextEditingController messageTextController;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.pinkBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 4, blurRadius: 7,
            offset: Offset(0, -4), // changes position of shadow
          ),
        ],
      ),
      child: SafeArea(
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50)
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.emoji_emotions,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: TextFormField(
                      controller: messageTextController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                          horizontal: width / (360 / 16), vertical: height / (724 / 18)),
                          hintText: 'Сообщение',
                          labelStyle: AppFontStyles.blueSmallStyle)),
                    ),
                    Icon(Icons.attach_file,color: Colors.grey,),
                  ],
                ),
              )
            ),
            SizedBox(width: 5,),
            ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppGradinets.mainButtonGradient,
                ),
                child: IconButton(
                  icon: Icon(Icons.voice_chat_rounded,color: Colors.white),
                  onPressed: () {},
                  splashRadius: 5,
                  splashColor: Colors.white,
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}