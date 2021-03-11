import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_view_model.dart';
import 'package:swipeable/swipeable.dart';
import 'package:vibrate/vibrate.dart';

class MessageCell extends StatefulWidget {
  final MessageViewModel messageViewModel;
  final int nextMessageUserID;
  final int prevMessageUserID;
  final Function(MessageViewModel) onReply;
  

  const MessageCell({
    @required this.messageViewModel,
    @required this.onReply,
    this.nextMessageUserID,
    this.prevMessageUserID,
    Key key, 
  }) : super(key: key);

  @override
  _MessageCellState createState() => _MessageCellState();
}

class _MessageCellState extends State<MessageCell> {
  bool leftSelected;

  bool rightSelected;
  void initState() {
    leftSelected = false;
    rightSelected = false;
    super.initState();
  }

  Future<void> vibrate() async {
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
      child: Swipeable(
      background: Container(
        width: MediaQuery.of(context).size.width - 32,
        child: ListTile(
          leading: !widget.messageViewModel.isMine ? Icon(Icons.reply) : SizedBox(),
          trailing: widget.messageViewModel.isMine ? Icon(Icons.reply) : SizedBox(),
            ),
          ),
          threshold: 64.0,
          onSwipeLeft: () {
            vibrate();
            widget.onReply(widget.messageViewModel);
          },
          onSwipeRight: () {
            vibrate();
            widget.onReply(widget.messageViewModel);
          },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: widget.messageViewModel.isMine ?
          MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            LimitedBox(
            maxWidth: w * 0.8,
            child: FocusedMenuHolder(
               blurSize: 5.0,
               animateMenuItems: true,
               blurBackgroundColor: Colors.black54,
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
                decoration: widget.messageViewModel.getCellDecoration(
                  previousMessageUserID: widget.prevMessageUserID, 
                  nextMessageUserID: widget.nextMessageUserID
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: widget.messageViewModel.isMine ? 
                    CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (!widget.messageViewModel.isMine) 
                          Text(
                            widget.messageViewModel.userNameText,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                              color: widget.messageViewModel.color,
                            ),
                            textAlign: TextAlign.left,
                          ),

                        if (widget.messageViewModel.isMine) 
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Image.asset(
                              widget.messageViewModel.readImageName, width: 20, height: 8
                            )
                          ),

                        Text(
                          widget.messageViewModel.time,
                          style: widget.messageViewModel.isMine ? 
                            AppFontStyles.whiteGrey12w400 : AppFontStyles.grey12w400, 
                          textAlign: TextAlign.right
                        )
                      ],
                      mainAxisSize:  MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),

                    if (widget.messageViewModel.messageText != null) 
                      Text(
                        widget.messageViewModel.messageText, 
                        style: !widget.messageViewModel.isMine ? 
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
