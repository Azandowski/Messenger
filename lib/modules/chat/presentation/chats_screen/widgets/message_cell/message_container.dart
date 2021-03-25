import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/application.dart';
import 'package:messenger_mobile/core/blocs/audioplayer/bloc/audio_player_bloc.dart';
import 'package:messenger_mobile/core/widgets/independent/map/map_view.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/file_media.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_media_block.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/photo_gallery_screen.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/components/contact_item.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/components/forward_container.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/message_cell/photo_cell.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/name_time_read_container.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/open_chat_cubit/open_chat_cubit.dart';

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
  
  NavigatorState get _navigator => sl<Application>().navKey.currentState;


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





// MARK: - Helpers

extension MessageContainerExtension on MessageContainer {
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

  List<Widget> returnMediaWidgets(
    MessageViewModel messageViewModel, 
    AudioPlayerBloc audioPlayerBloc, 
    bool isMine,
    double width,
  ) {
    var files = messageViewModel.message.files;
    if (files[0].type == TypeMedia.image) {
      switch (files.length) {
        case 1:
          return[
            PreviewPhotoLarge(
              url: files[0].url
            )
          ];
          break;
        case 2:
          var a = (width*0.8 - 22)/2;
          
          return [
            Row(
              children: [
                PreviewPhotoWidget(
                  a: a, 
                  url: files[0].url,
                ),
                SizedBox(
                  width: 4
                ),
                PreviewPhotoWidget(
                  a: a, 
                  url: files[1].url
                ),
              ]
          )];

          break;
        default:
          var a = (width*0.8 - 26)/3;
          return [
            Row(
              children: [
                PreviewPhotoWidget(
                  a: a, 
                  url: files[0].url
                ),
                SizedBox(width: 4,),
                PreviewPhotoWidget(
                  a: a, 
                  url: files[1].url,
                ),
                SizedBox(width: 4,),
                files.length > 3 ? PreviewMorePhoto(
                  url: files[2].url,
                  a: a,
                  moreCount: files.length - 3,
                  onMore: (){
                    _navigator.push(PhotoGalleryScreen.route(messageViewModel, files.map((e) => e.url).toList()));
                  },
                ) : 
                PreviewPhotoWidget(
                  a: a, 
                  url: files[2].url
                ),
              ]
            )
          ];
      }
    } else {
      return files.map((e) {
        switch (e.type){
          case TypeMedia.audio:
            return AudioPlayerElement(
              file: e,
              isMine: isMine,
              audioPlayerBloc: audioPlayerBloc,
            );
            break;
        default:
          return Text('salam');
          break;
        }
      }).toList();
    }
  }
} 