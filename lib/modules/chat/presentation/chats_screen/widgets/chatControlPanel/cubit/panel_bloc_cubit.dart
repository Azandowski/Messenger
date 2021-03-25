import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_media_block.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/media/domain/usecases/get_images_from_gallery.dart';

import '../../../../../data/models/message_view_model.dart';

part 'panel_bloc_state.dart';

class PanelBlocCubit extends Cubit<PanelBlocState> {
  final GetImagesFromGallery getImagesFromGallery;
  final ChatBloc chatBloc;
  PanelBlocCubit({
    @required this.getImagesFromGallery,
    @required this.chatBloc,
  }) : super(PanelBlocInitial(showBottomPanel: false)) {
    _textController.sink.addError("Invalid value entered!");
  }

  addMessage(MessageViewModel message){
    emit(PanelBlocReplyMessage(
      messageViewModel: message,
      showBottomPanel: state.showBottomPanel
    ));
  }
  
  detachMessage(){
    emit(PanelBlocInitial(
      showBottomPanel: state.showBottomPanel
    ));
  }

  toggleBottomPanel () {
    emit(PanelBlocInitial(
      showBottomPanel: !state.showBottomPanel
    ));
  }

  var _textController = StreamController<String>.broadcast();
  Stream<String> get textStream => _textController.stream;

  updateText(String text) {
    (text == null || text == "")
      ? _textController.sink.addError("Invalid value entered!")
      : _textController.sink.add(text);
  }

  clear(){
    _textController.add(null);
    _textController.sink.addError("Invalid value entered!");
  }

  dispose() {
    _textController.close();
  }

  getGalleryImages() async {
    final result =  await getImagesFromGallery(NoParams());
    result.fold((l) => print('error'), (assets){
      if(assets.length > 0){
        chatBloc.add(MessageSend(
          fieldAssets: FieldAssets(assets: assets, fieldKey: TypeMedia.image)
        ));
      }
    });
  }
}
