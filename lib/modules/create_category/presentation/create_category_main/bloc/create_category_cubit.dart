import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:messenger_mobile/modules/create_category/domain/usecases/create_category.dart';

part 'create_category_state.dart';

class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  
  // * * Constructor
  
  final CreateCategoryUseCase createCategory;
  
  CreateCategoryCubit({
    @required this.createCategory
  }) : super(CreateCategoryLoading());

  // * * Events

  void initCubit () {
    emit(CreateCategoryNormal(
      imageFile: imageFile, 
      chats: [])
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
