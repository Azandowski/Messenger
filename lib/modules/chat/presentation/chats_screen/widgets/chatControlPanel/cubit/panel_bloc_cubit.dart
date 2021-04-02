import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/core/widgets/independent/dialogs/achievment_view.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_media_block.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/media/domain/usecases/get_audios.dart';
import 'package:messenger_mobile/modules/media/domain/usecases/get_image.dart';
import 'package:messenger_mobile/modules/media/domain/usecases/get_images_from_gallery.dart';
import 'package:messenger_mobile/modules/media/domain/usecases/get_video.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../../../../../data/models/message_view_model.dart';

part 'panel_bloc_state.dart';

class PanelBlocCubit extends Cubit<PanelBlocState> {
  final GetImagesFromGallery getImagesFromGallery;
  final ChatBloc chatBloc;
  final GetVideo getVideoUseCase;
  final GetAudios getAudios;
  final GetImage getImage;
  PanelBlocCubit({
    @required this.getImagesFromGallery,
    @required this.chatBloc,
    @required this.getVideoUseCase,
    @required this.getAudios,
    @required this.getImage,
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
    final Either<Failure, List<Asset>> result =  await getImagesFromGallery(NoParams());
    result.fold((l) => print('error'), (assets) async {
      if(assets.length > 0) {
        var memoryPhotos = await getUIint8List(assets);

        chatBloc.add(MessageSend(
          fieldAssets: FieldAssets(assets: assets, fieldKey: TypeMedia.image),
          memoryPhotos: memoryPhotos,
        ));
      }
    });
  }
  Future<List<Uint8List>> getUIint8List(List<Asset> assets) async {
    return Future.wait(assets.map( (e) async {
      var byteData = await e.getByteData();
      return byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    }).toList());
  }
  getCameraPhoto() async {
    final result =  await getImage(ImageSource.camera);
    result.fold((l) => print('error'), (file){
      if(file != null){
        chatBloc.add(MessageSend(
          fieldFiles: FieldFiles(files: [file], fieldKey: TypeMedia.image),
          memoryPhotos: [file.readAsBytesSync()],
        ));
      }
    });
  }

   getAudio() async {
    final result =  await getAudios(NoParams());
    result.fold((l) => print('error'), (audios){
      if(audios != null){
        chatBloc.add(MessageSend(
          fieldFiles: FieldFiles(files: audios, fieldKey: TypeMedia.audio)
        ));
      }
    });
  }

  getVideo()async{
    final result =  await getVideoUseCase(NoParams());
    result.fold((error) {
      emit(PanelBlocError(showBottomPanel: this.state.showBottomPanel, errorMessage: error.message));
    }, (video){
      if(video != null){
        chatBloc.add(MessageSend(
          fieldFiles: FieldFiles(files: [video], fieldKey: TypeMedia.video)
        ));
      }
    });
  }
}
