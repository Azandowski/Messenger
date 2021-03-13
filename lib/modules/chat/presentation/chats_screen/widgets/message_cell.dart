import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_view_model.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/helpers/messageCellAction.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chatControlPanel/forward_container.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/name_time_read_container.dart';
import 'package:swipeable/swipeable.dart';
import 'package:vibrate/vibrate.dart';

class MessageCell extends StatefulWidget {
  final MessageViewModel messageViewModel;
  final int nextMessageUserID;
  final int prevMessageUserID;
  final Function(MessageViewModel) onReply;
  final Function(MessageCellActions) onAction;

  const MessageCell({
    @required this.messageViewModel,
    @required this.onAction,
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
              menuItems: widget.messageViewModel.actionsList.map((e) => FocusedMenuItem(title: Text(e.title),trailingIcon: e.icon, onPressed: (){
                widget.onAction(e);
              }),).toList(),
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
                crossAxisAlignment: widget.messageViewModel.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  NameTimeBloc(messageViewModel: widget.messageViewModel),
                  if(widget.messageViewModel.message.transfer.isNotEmpty)
                  ...returnForwardColumn(widget.messageViewModel.message.transfer),
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

List<Widget> returnForwardColumn(List<Message> transfers) {
    return transfers.map((e) => ForwardContainer(messageViewModel: MessageViewModel(e),)).toList();
}

