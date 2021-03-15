import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../../data/models/message_view_model.dart';

part 'panel_bloc_state.dart';

class PanelBlocCubit extends Cubit<PanelBlocState> {

  PanelBlocCubit() : super(PanelBlocInitial()){
    _textController.sink.addError("Invalid value entered!");
  }

  addMessage(MessageViewModel message){
    emit(PanelBlocReplyMessage(messageViewModel: message));
  }
  
  detachMessage(){
    emit(PanelBlocInitial());
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
}
