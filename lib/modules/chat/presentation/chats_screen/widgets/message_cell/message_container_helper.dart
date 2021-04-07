import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/blocs/audioplayer/bloc/audio_player_bloc.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_view_model.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_media_block.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/photo_gallery_screen.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/components/forward_container.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/message_cell/audio_player_element.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/message_cell/photo_cell.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/message_cell/play_video_button.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/message_cell/video_player_element.dart';

import 'circullar_upload_indicator.dart';
import 'message_container.dart';

extension MessageContainerExtension on MessageContainer {
  List<Widget> returnForwardColumn(
    List<Message> transfers,
    {
      Function(int) onClickForwardMessage
    }
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
      if(messageViewModel.message.files[0].isLocal){
        return returnLoadPhotoRow(messageViewModel.message.files[0].memoryPhotos, width, (){});
      }else{
        return returnPhotoRow(files, width, (){
          navigator.push(PhotoGalleryScreen.route(messageViewModel, files.map((e) => e.url).toList()));
        });
      }
    } else {
      return files.map((e) {
        switch (e.type){
          case TypeMedia.audio:
            return AudioPlayerElement(
              message: messageViewModel.message,
              file: e,
              isMine: isMine,
              audioPlayerBloc: audioPlayerBloc,
            );
            break;
            case TypeMedia.video:
            if(e.id == null){
              return PreviewVideo(
                url: e.url,
                centerWidget: StreamBuilder<double>(
                  stream: messageViewModel.message.uploadController?.stream,
                  builder: (context, progress) {
                  var percent = progress?.data ?? 0.0;
                    return CircullarUploadIndicator(percent: percent, radius: width * 0.1,);
                  }
                ),
              );
            }else{
              return PreviewVideo(
                url: e.url,
                centerWidget: PlayVideoButton(url: e.url),
              );
            }
            break;
        default:
          return Text('salam');
          break;
        }
      }).toList();
    }
  }
}

List<Widget> returnPhotoRow(files, width, Function onMore){
  const placeholderLink = 'https://via.placeholder.com/150.png?text=Loading';
  switch (files.length) {
    case 1:
      return[
        PreviewPhotoLarge(
          url: files[0].url ?? placeholderLink
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
              url: files[0].url ?? placeholderLink, 
            ),
            SizedBox(
              width: 4
            ),
            PreviewPhotoWidget(
              a: a, 
              url: files[1].url ?? placeholderLink
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
              url: files[0].url ?? placeholderLink
            ),
            SizedBox(width: 4,),
            PreviewPhotoWidget(
              a: a, 
              url: files[1].url ?? placeholderLink
            ),
            SizedBox(width: 4,),
            files.length > 3 ? PreviewMorePhoto(
              url: files[2].url ?? placeholderLink,
              a: a,
              isLocal: false,
              moreCount: files.length - 3,
              onMore: onMore,
            ) : 
            PreviewPhotoWidget(
              a: a, 
              url: files[2].url ?? placeholderLink
            ),
          ]
        )
    ];
  }
}

List<Widget> returnLoadPhotoRow(List<Uint8List> data, width, Function onMore){
  switch (data.length) {
    case 1:
      return[
        PreviewPhotoLarge(
          url: data[0],
          isLocal: true,
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
              isLocal: true,
              url: data[0], 
            ),
            SizedBox(
              width: 4
            ),
            PreviewPhotoWidget(
              a: a, 
              isLocal: true,
              url: data[1],
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
              isLocal: true,
              url: data[0],
            ),
            SizedBox(width: 4,),
            PreviewPhotoWidget(
              a: a, 
              isLocal: true,
              url: data[1],
            ),
            SizedBox(width: 4,),
            data.length > 3 ? PreviewMorePhoto(
              isLocal: true,
              url: data[2],
              a: a,
              moreCount: data.length - 3,
              onMore: onMore,
            ) : 
            PreviewPhotoWidget(
              isLocal: true,
              a: a, 
              url: data[2]
            ),
          ]
        )
    ];
  }
}