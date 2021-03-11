import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_view_model.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:vibrate/vibrate.dart';

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

  static Future<void> vibrate() async {
    bool canVibrate = await Vibrate.canVibrate;
    if(canVibrate){
      Vibrate.feedback(FeedbackType.medium);
    }
   }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SwipeTo(
          onLeftSwipe: () {
            if(messageViewModel.isMine){
              vibrate();
            }
            print('Callback from Swipe To Right');
          },
          onRightSwipe: () {
            if(!messageViewModel.isMine){
              vibrate();
            }
            print('Callback from Swipe To Right');
          },
          
          animationDuration: Duration(milliseconds: 300),
          offsetDx: 0.5,
          child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: messageViewModel.isMine ?
            MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            LimitedBox(
              maxWidth: w * 0.8,
              child: FocusedMenuHolder(
                 blurSize: 5.0,
                 animateMenuItems: true,
                 blurBackgroundColor: Colors.black54,
                 openWithTap: false,
                 menuOffset: 10.0, 
                 menuBoxDecoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.all(Radius.circular(15.0))),
                 menuItems: <FocusedMenuItem>[
                    FocusedMenuItem(title: Text("Open"),trailingIcon: Icon(Icons.open_in_new) ,onPressed: (){}),
                    FocusedMenuItem(title: Text("Share"),trailingIcon: Icon(Icons.share) ,onPressed: (){}),
                    FocusedMenuItem(title: Text("Favorite"),trailingIcon: Icon(Icons.favorite_border) ,onPressed: (){}),
                    FocusedMenuItem(title: Text("Delete",style: TextStyle(color: Colors.redAccent),),trailingIcon: Icon(Icons.delete,color: Colors.redAccent,) ,onPressed: (){}),
                  ],
                  onPressed: (){
                    vibrate();
                  },
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
            ),
          ],
        ),
      ),
    );
  }
}
