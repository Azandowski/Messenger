import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/blocs/audioplayer/bloc/audio_player_bloc.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/name_time_read_container.dart';

class MessageContainer extends StatelessWidget {
  const MessageContainer({
    Key key,
    @required this.widget,
    @required this.audioPlayerBloc,
  }) : super(key: key);

  final MessageCell widget;
  final AudioPlayerBloc audioPlayerBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        if(widget.messageViewModel.hasMedia) 
        ...returnAuidoWidgets(widget.messageViewModel.message.files,audioPlayerBloc, widget.messageViewModel.isMine),
      ],
    ),
          );
  }
}