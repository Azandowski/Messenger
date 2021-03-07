import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';


part 'chats_cubit_state.dart';

class ChatsCubit extends Cubit<ChatsCubitState> {
  
  final ChatsRepository repository;

  ChatsCubit(this.repository) : super(
    ChatsCubitStateNormal(
      currentTabIndex: 0,
    )
  ) {
    _handleInit();
  }
  
  // * * Methods

  void _handleInit () async {
    File wallpaperFile = await repository.getLocalWallpaper();
    if (wallpaperFile != null) {
      emit(
        ChatsCubitStateNormal(
          currentTabIndex: this.state.currentTabIndex,
          wallpaperFile: wallpaperFile
        )
      );
    }
  }

  Future<void> setWallpaper (File file) async {
    emit(
      ChatsCubitStateNormal(
        currentTabIndex: this.state.currentTabIndex,
        wallpaperFile: file
      )
    );
    
    return repository.setLocalWallpaper(file);
  }

  void tabUpdate(int index) {
    emit(ChatsCubitStateNormal(
      currentTabIndex: index,
      wallpaperFile: this.state.wallpaperFile
    ));
  }

  void didSelectChat(int index) {
    emit(
      ChatsCubitSelectedOne(
        currentTabIndex: this.state.currentTabIndex, 
        selectedChatIndex: index,
        wallpaperFile: this.state.wallpaperFile
      )
    );
  }

  void didCancelChatSelection () {
    emit(
      ChatsCubitStateNormal(
        currentTabIndex: this.state.currentTabIndex,
        wallpaperFile: this.state.wallpaperFile
      )
    );
  }

  // * * Useful Getters

  int get selectedChatIndex {
    if (this.state is ChatsCubitSelectedOne) {
      return (this.state as ChatsCubitSelectedOne).selectedChatIndex;
    } else {
      return null;
    }
  }

  ChatEntity get selectedChat {
    return null;
  }
}
