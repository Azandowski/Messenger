
import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/widgets/independent/map/map_view.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_view_model.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';

import 'components/forward_container.dart';
import 'message_cell.dart';
import 'name_time_read_container.dart';

class MessageContainer extends StatelessWidget {
  const MessageContainer({
    @required this.widget,
    @required this.onClickForwardMessage,
    Key key,
  }) : super(key: key);

  final MessageCell widget;
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

          if (widget.messageViewModel.hasToShowMap)
            MapView(
              position: widget.messageViewModel.mapLocation, 
              width: MediaQuery.of(context).size.width * 0.8, 
              heigth: 128.0
            ) 
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
}

