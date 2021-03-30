import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:messenger_mobile/core/blocs/audioplayer/bloc/audio_player_bloc.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/cubit/translation_cubit.dart/translation_cubit.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:swipeable/swipeable.dart';
import 'package:vibrate/vibrate.dart';
import '../../../../../../app/appTheme.dart';
import '../../../../data/models/message_view_model.dart';
import '../../helpers/messageCellAction.dart';
import 'message_container.dart';

class MessageCell extends StatefulWidget {
  
  final MessageViewModel messageViewModel;
  final int nextMessageUserID;
  final int prevMessageUserID;
  final Function(MessageViewModel) onReply;
  final Function(MessageCellActions) onAction;
  final Function(int) onClickForwardMessage;
  final Function onTap; 
  final bool isSwipeEnabled;
  final ChatRepository chatRepository;

  const MessageCell({
    @required this.messageViewModel,
    @required this.onAction,
    @required this.onReply,
    @required this.onClickForwardMessage,
    this.isSwipeEnabled = true,
    this.onTap,
    this.nextMessageUserID,
    this.prevMessageUserID,
    this.chatRepository,
    Key key, 
  }) : super(key: key);

  @override
  _MessageCellState createState() => _MessageCellState();
}

class _MessageCellState extends State<MessageCell> {
  
  bool leftSelected;
  AudioPlayerBloc _audioPlayerBloc;
  TranslationCubit _translationCubit;
  bool rightSelected;
  
  @override
  void initState() {
    leftSelected = false;
    rightSelected = false;
    _audioPlayerBloc = BlocProvider.of<AudioPlayerBloc>(context);
    _translationCubit = TranslationCubit(
      widget.chatRepository, 
      messageID: widget.messageViewModel.message.id
    );

    super.initState();
  }

  @override
  void dispose () { 
    _translationCubit.close();
    super.dispose();
  }

  
  Future<void> vibrate() async {
    bool canVibrate = await Vibrate.canVibrate;
    
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.medium);
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
      color: widget.messageViewModel.isSelected ? AppColors.paleIndicatorColor : Colors.transparent,
      child: Swipeable(
        background: Container(
          child: ListTile(
            leading: !widget.messageViewModel.isMine ? Icon(Icons.reply) : SizedBox(),
            trailing: widget.messageViewModel.isMine ? Icon(Icons.reply) : SizedBox(),
          ),
        ),
        threshold: 64.0,
        onSwipeLeft: () {
          if (widget.isSwipeEnabled) {
            vibrate();
            widget.onReply(widget.messageViewModel);
          }
        },
        onSwipeRight: () {
          if (widget.isSwipeEnabled) {
            vibrate();
            widget.onReply(widget.messageViewModel);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: widget.messageViewModel.isMine ?
            MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              width: w * 0.8,
              child: FocusedMenuHolder(
                blurSize: 5.0,
                animateMenuItems: true,
                blurBackgroundColor: Colors.black54,
                menuOffset: 10.0, 
                menuBoxDecoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.all(Radius.circular(15.0))),
                menuItems: widget.messageViewModel.getActionsList(
                  isReplyEnabled: widget.isSwipeEnabled
                ).map((e) => FocusedMenuItem(
                    title: Text(
                      e.title
                    ),
                    trailingIcon: e.icon, 
                    onPressed: () {
                      if (e == MessageCellActions.translateMessage) {
                        _translationCubit.translateMessage(
                          text: widget.messageViewModel.message.text, 
                          messageID: widget.messageViewModel.message.id
                        );
                      } else {
                        widget.onAction(e);
                      }
                    })
                  ).toList(),
                onPressed: () {
                  widget.onTap();
                  vibrate();
                },
                child: MessageContainer(
                  widget: widget,
                  onClickForwardMessage: widget.onClickForwardMessage,
                  audioPlayerBloc: _audioPlayerBloc,
                  translationCubit: _translationCubit
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}