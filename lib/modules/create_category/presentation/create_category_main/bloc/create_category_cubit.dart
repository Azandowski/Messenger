import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../../chats/domain/entities/category.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../../domain/usecases/create_category.dart';

part 'create_category_state.dart';

class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  
  // * * Constructor
  
  final CreateCategoryUseCase createCategory;
  
  CreateCategoryCubit({
    @required this.createCategory
  }) : super(CreateCategoryLoading()){
     initCubit();
  }

  // * * Events

  void initCubit () {
    emit(CreateCategoryNormal(
      imageFile: imageFile, 
      chats: [])
    );
  }

  void addChats(List<ChatEntity> comingChats){
    emit(CreateCategoryNormal(
      imageFile: imageFile, 
      chats: comingChats)
    );
  }

  void deleteChat(ChatEntity chat){
    var updatedChats = (state as CreateCategoryNormal).chats;
    updatedChats.remove(chat);
    emit(CreateCategoryNormal(
      imageFile: imageFile, 
      chats: updatedChats)
    );
  }

  // * * Local Data

  File imageFile;

  int get chatCounts {
    if (state is CreateCategoryNormal) {
      return (state as CreateCategoryNormal).chats.length;
    } else {
      return 0;
    }
  }
}
