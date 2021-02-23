import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/usecases/get_categories.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/usecases/params.dart';

import '../../../../../locator.dart';

part 'chats_cubit_state.dart';

class ChatsCubit extends Cubit<ChatsCubitState> {
  
  final GetCategories getCategories;
  
  ChatsCubit({
    @required this.getCategories
  }) : super(ChatsCubitNormal(
    chatListsState: ChatListsLoading(), 
    chatCategoriesState: ChatCategoriesLoading()
  ));

  void initCubit () {
    loadCategories(token: sl<AuthConfig>().token);
  }

  Future<void> loadCategories ({
    @required String token
  }) async {
    final response = await getCategories.call(GetCategoriesParams(token: token));
    response.fold((failure) {
      emit(ChatsCubitError(errorMessage: failure.message));
    }, (categories) {
      ChatListsState listsState = this.state is ChatsCubitNormal ? 
        (this.state as ChatsCubitNormal).chatListsState : ChatListsLoading();

      emit(ChatsCubitNormal(
        chatListsState: listsState,
        chatCategoriesState: ChatCategoriesLoaded(categories: categories)
      ));
    });
  }
}
