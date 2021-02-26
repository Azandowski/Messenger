import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/get_chats.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/params.dart';

import '../../../../../locator.dart';
part 'chats_cubit_state.dart';

class ChatsCubit extends Cubit<ChatsCubitState> {

  final GetChats getChats;
  int currentTab;
  PaginatedResult<ChatEntity> chats;

  PaginationData paginationData = PaginationData(
    isFirstPage: true,
    nextPageUrl: null
  );

  ChatsCubit(this.getChats) : super(
    ChatsCubitLoading()
  );
  
  // MARK: - Public Options

  void tabUpdate(int index) {
    currentTab = index;
    emit(ChatsCubitLoaded(
      currentTabIndex: index,
      chats: chats
    ));
  }

  Future<void> loadAllChats () async {
    String token = sl<AuthConfig>().token;
    var response = await getChats(GetChatsParams(
      token: token,
      paginationData: paginationData
    ));

    response.fold(
      (failure) => emit(ChatsCubitError(errorMessage: failure.message)), 
      (loadedChats) {
        chats = loadedChats;
        emit(ChatsCubitLoaded(
          chats: loadedChats, 
          currentTabIndex: currentTab
        ));
      }
    );
  }
}
