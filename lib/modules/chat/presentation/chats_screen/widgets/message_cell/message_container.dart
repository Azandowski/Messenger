import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/blocs/audioplayer/bloc/audio_player_bloc.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/file_media.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_media_block.dart';
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
            ...returnMediaWidgets(
              widget.messageViewModel.message.files,
              audioPlayerBloc, 
              widget.messageViewModel.isMine,
              MediaQuery.of(context).size.width,
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

  List<Widget> returnMediaWidgets(
    List<FileMedia> files, 
    AudioPlayerBloc audioPlayerBloc, 
    bool isMine,
    double width,
  ) {
    if(files[0].type == TypeMedia.image){
      switch (files.length) {
        case 1:
          return[PreviewPhotoLarge(url: files[0].url,)];
          break;
        case 2:
          var a = (width*0.8 - 22)/2;
          return [
            Row(
              children: [
                PreviewPhotoWidget(a: a, url: files[0].url,),
                SizedBox(width: 4,),
                PreviewPhotoWidget(a: a, url: files[1].url,),
              ]
          )];
        default:
          var a = (width*0.8 - 26)/3;
          return [
            Row(
              children: [
                PreviewPhotoWidget(a: a, url: files[0].url,),
                SizedBox(width: 4,),
                PreviewPhotoWidget(a: a, url: files[1].url,),
                SizedBox(width: 4,),
                PreviewPhotoWidget(a: a, url: files[2].url,),
              ]
            )
          ];
      }
    }else{
      return files.map((e){
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

class PreviewPhotoWidget extends StatelessWidget {
  const PreviewPhotoWidget({
    Key key,
    @required this.a,
    @required this.url,
  }) : super(key: key);

  final double a;
  final url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        fadeInDuration: const Duration(milliseconds: 400),
        filterQuality: FilterQuality.low,
        imageUrl: url,
        width: a,
        height: a,
        fit: BoxFit.cover,
        placeholder: (context, url) => Icon(
          Icons.image,
          color: Colors.white,
        ),
        errorWidget: (context, url, error) => Icon(
            Icons.error,
            color: Colors.white,
          ),
      ),
    );
  }
}

class PreviewPhotoLarge extends StatelessWidget {
  const PreviewPhotoLarge({
    Key key,
    @required this.url,
  }) : super(key: key);

  final url;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            fadeInDuration: const Duration(milliseconds: 400),
            filterQuality: FilterQuality.low,
            imageUrl: url,
            fit: BoxFit.cover,
            placeholder: (context, url) => Icon(
              Icons.image,
              color: Colors.white,
            ),
            errorWidget: (context, url, error) => Icon(
                Icons.error,
                color: Colors.white,
              ),
          ),
        ),
    );
  }
}