import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/blocs/audioplayer/bloc/audio_player_bloc.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/file_media.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/components/forward_container.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/name_time_read_container.dart';

import 'audio_player_element.dart';

class MessageContainer extends StatelessWidget {
  const MessageContainer({
    Key key,
    @required this.widget,
    @required this.audioPlayerBloc,
    @required this.onClickForwardMessage
  }) : super(key: key);

  final MessageCell widget;
  final AudioPlayerBloc audioPlayerBloc;
  final Function(int) onClickForwardMessage; 

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
          NameTimeBloc(
            messageViewModel: widget.messageViewModel
          ),

          if (widget.messageViewModel.message.transfer.isNotEmpty)
            ...returnForwardColumn(
              widget.messageViewModel.message.transfer,
              onClickForwardMessage: onClickForwardMessage
            ),
          
          if (widget.messageViewModel.messageText != null) 
            Text(
              widget.messageViewModel.messageText, 
              style: !widget.messageViewModel.isMine ? 
              AppFontStyles.black14w400 : AppFontStyles.white14w400,
              textAlign: TextAlign.left,
            ),

          if (widget.messageViewModel.hasMedia) 
            ...returnAuidoWidgets(
              widget.messageViewModel.message.files,
              audioPlayerBloc, 
              widget.messageViewModel.isMine
            ),
        ],
      ),
    );
  }


  List<Widget> returnForwardColumn(
    List<Message> transfers,
    {Function(int) onClickForwardMessage}
  ) {
    return transfers.map((e) => InkWell(
      onTap: () {
        onClickForwardMessage(e.id);
      },
      child: ForwardContainer(
        messageViewModel: MessageViewModel(e)
      ),
    )).toList();
  }

  List<Widget> returnAuidoWidgets(
    List<FileMedia> files, 
    AudioPlayerBloc audioPlayerBloc, 
    bool isMine
  ) {
    return files.map((e) => AudioPlayerElement(
      file: e,
      isMine: isMine,
      audioPlayerBloc: audioPlayerBloc,
    )).toList();
  }
}