import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/application.dart';
import 'package:messenger_mobile/core/blocs/audioplayer/bloc/audio_player_bloc.dart';
import 'package:messenger_mobile/core/widgets/independent/map/map_view.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'message_container_helper.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/components/contact_item.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/name_time_read_container.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/open_chat_cubit/open_chat_cubit.dart';

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
  
  NavigatorState get navigator => sl<Application>().navKey.currentState;

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

          ...returnMessageCellBody(context)
        ],
      ),
    );
  }

  // MARK: - Message Cell Body 

  List<Widget> returnMessageCellBody (BuildContext context) {
    switch (widget.messageViewModel.presentationType) {
      case MessageCellPresentationType.location:
        return [
          _buildLocationView(context)
        ];
      case MessageCellPresentationType.contact:
        return [
          _buildContextItemView(context)
        ];
      default: 
        return _buildDefaultMessageBody(context);
    }
  }

  // Показать геолокацию
  MapView _buildLocationView (BuildContext context) {
    return MapView(
      position: widget.messageViewModel.mapLocation, 
      width: MediaQuery.of(context).size.width * 0.8, 
      heigth: 128.0,
      locationAddress: widget.messageViewModel.mapLocationAddress,
      locationAddressStyle: !widget.messageViewModel.isMine ? 
        AppFontStyles.black14w400 : AppFontStyles.white14w400,
    );
  }

  // Показать контакт
  ContactItemMessage _buildContextItemView (BuildContext context) {
    return ContactItemMessage(
      isMyMessage: widget.messageViewModel.isMine,
      messageUser: widget.messageViewModel.contactItem,
      onTapOpenChat: () {
        context.read<OpenChatCubit>().createChatWithUser(widget.messageViewModel.contactItem.id);
      },
    );
  }

  // Default Message body

  List<Widget> _buildDefaultMessageBody (BuildContext context) {
    return [
      if (widget.messageViewModel.messageText != null) 
        Text(
          widget.messageViewModel.messageText, 
          style: !widget.messageViewModel.isMine ? 
            AppFontStyles.black14w400 : AppFontStyles.white14w400,
          textAlign: TextAlign.left,
        ),

      if (widget.messageViewModel.hasMedia) 
        ...returnMediaWidgets(
          widget.messageViewModel,
          audioPlayerBloc, 
          widget.messageViewModel.isMine,
          MediaQuery.of(context).size.width,
        ),
    ];
  }
}
