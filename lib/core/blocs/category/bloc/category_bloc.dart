import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../modules/category/domain/repositories/category_repository.dart';
import '../../../../modules/category/domain/usecases/delete_category.dart';
import '../../../../modules/category/domain/usecases/reorder_category.dart';
import '../../../../modules/chats/domain/entities/category.dart';
import '../../chat/bloc/bloc/chat_cubit.dart';

part 'category_event.dart'; 
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {

  final CategoryRepository repository;
  final DeleteCategory deleteCategory;
  final ReorderCategories reorderCategories;
  final ChatGlobalCubit chatGlobalCubit;
  CategoryBloc({
    @required this.repository,
    @required this.deleteCategory,
    @required this.reorderCategories,
    this.chatGlobalCubit,
  }) : super(CategoryEmpty()) {
    _categoriesSubscription = repository.categoryListController.stream
      .listen((categories) => add(CategoriesChanged(newCategories: categories)));

    if(chatGlobalCubit != null){
      _chatCubitSubscription = chatGlobalCubit.listen((chatState) { 
        print('state changed');
        if(chatState is ChatCategoryReadCountChanged){
          add(CategoryReadCountChanged(
            categoryID: chatState.categoryID,
            newReadCount: chatState.newReadCount,
          ));
        }
      });
    }
  }
  StreamSubscription _chatCubitSubscription;

  StreamSubscription<List<CategoryEntity>> _categoriesSubscription;

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is CategoriesChanged) {
      yield CategoryLoaded(categoryList: event.newCategories);
    } else if (event is CategoriesReset) {
      yield CategoryEmpty();
    } else if (event is CategoryRemoving) {
      yield CategoriesUpdating(categoryList: this.state.categoryList);
      var result = await deleteCategory(event.categoryId);
      
      yield* result.fold((l) async* {
        yield CategoriesErrorHappened(
          categoryList: this.state.categoryList,
          message: l.message
        );
      }, (r) {
        print('SOMETHING HAPPENED');
        //Stream Updates State
      });
    } else if (event is CategoriesReordered) {
      yield CategoriesUpdating(categoryList: this.state.categoryList);

      var result = await reorderCategories(event.categoryUpdated);
      yield* result.fold(
        (failure) async* {
          yield CategoriesErrorHappened(
            categoryList: this.state.categoryList,
            message: failure.message
          );
        }, (data) async* {
          repository.categoryListController.add(data);
          yield CategoryLoaded(
            categoryList: data
          );
      });
    } else if (event is CategoryReadCountChanged) {
        yield* _mapCountChangeToState(event);
    }
  }

  Stream<CategoryState> _mapCountChangeToState(CategoryReadCountChanged event) async* {
    int index = this.state.categoryList.indexWhere((element) => element.id == event.categoryID);
    if (index != -1) {
      var newCategory = CategoryEntity(
        id: this.state.categoryList[index].id, 
        name: this.state.categoryList[index].name, 
        avatar: this.state.categoryList[index].avatar, 
        totalChats: this.state.categoryList[index].totalChats, 
        noReadCount: event.newReadCount
      );

      final newCategories = this.state.categoryList.map(
        (e) => e.id == event.categoryID ? newCategory :  e.clone()
      ).toList();

      yield CategoryLoaded(
        categoryList: newCategories
      );
    }
  }
}
