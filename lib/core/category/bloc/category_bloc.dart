import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:messenger_mobile/modules/create_category/domain/repositories/create_category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {

  final CreateCategoryRepository repository;

  CategoryBloc({
    @required this.repository,
  }) : super(CategoryEmpty()){
    _categoriesSubscription = repository.categoryListController.stream
        .listen((categories) => add(CategoriesChanged(newCategories: categories)));
  }

  StreamSubscription<List<CategoryEntity>> _categoriesSubscription;

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if(event is CategoriesChanged){
     yield CategoryLoaded(categoryList: event.newCategories);
    }
  }

}
