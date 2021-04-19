import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

import '../../../../../core/utils/feedbac_taptic_helper.dart';
import '../../../../category/domain/entities/chat_entity.dart';
import '../../../data/repositories/chats_repository_impl.dart';
import '../../../domain/repositories/chats_repository.dart';

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
    (repository as ChatsRepositoryImpl).init();

    if (wallpaperFile != null) {
      emit(ChatsCubitStateNormal(
        currentTabIndex: this.state.currentTabIndex,
      ));
    } 
  }

  void tabUpdate(int index) {
    FeedbackEngine.showFeedback(FeedbackType.selection);

    emit(ChatsCubitStateNormal(
      currentTabIndex: index,
    ));
  }

  void didSelectChat(int index) {
    emit(
      ChatsCubitSelectedOne(
        currentTabIndex: this.state.currentTabIndex, 
        selectedChatIndex: index,
      )
    );
  }

  void didCancelChatSelection () {
    emit(
      ChatsCubitStateNormal(
        currentTabIndex: this.state.currentTabIndex,
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
