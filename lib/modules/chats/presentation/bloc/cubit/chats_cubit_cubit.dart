import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/config/auth_config.dart';
import '../../../../../locator.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/usecases/get_categories.dart';
import '../../../domain/entities/usecases/params.dart';

part 'chats_cubit_state.dart';

class ChatsCubit extends Cubit<ChatsCubitState> {
  final GetCategories getCategories;

  ChatsCubit({@required this.getCategories})
    : super(ChatsCubitNormal(
        chatListsState: ChatListsLoading(),
        chatCategoriesState: ChatCategoriesLoading()));

  void initCubit() {
    loadCategories(token: sl<AuthConfig>().token);
  }

  Future<void> loadCategories({@required String token}) async {
    final response =
        await getCategories.call(GetCategoriesParams(token: token));
    
    response.fold((failure) {
      emit(ChatsCubitError(errorMessage: failure.message));
    }, (categories) {
      ChatListsState listsState = this.state is ChatsCubitNormal
          ? (this.state as ChatsCubitNormal).chatListsState
          : ChatListsLoading();

      emit(ChatsCubitNormal(
        chatListsState: listsState,
        chatCategoriesState: ChatCategoriesLoaded(categories: categories)
      ));
    });
  }

  // MARK: - Getters

  List<CategoryEntity> get categories {
    if (this.state is ChatsCubitNormal) {
      if ((this.state as ChatsCubitNormal).chatCategoriesState is ChatCategoriesLoaded) {
        return ((this.state as ChatsCubitNormal).chatCategoriesState as ChatCategoriesLoaded).categories;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  bool get showCategoriesSpinner {
    var categoriesLoaded =  (state is ChatsCubitNormal) && (state as ChatsCubitNormal).chatCategoriesState is ChatCategoriesLoaded;
    return !categoriesLoaded && !(state is ChatsCubitError);
  }
}
