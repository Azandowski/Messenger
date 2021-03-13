import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/profile/presentation/widgets/profile_shimmer.dart';

import '../../../../modules/category/domain/repositories/category_repository.dart';
import '../../../../modules/category/domain/usecases/delete_category.dart';
import '../../../../modules/category/domain/usecases/reorder_category.dart';
import '../../../../modules/chats/domain/entities/category.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {

  final CategoryRepository repository;
  final DeleteCategory deleteCategory;
  final ReorderCategories reorderCategories;

  CategoryBloc({
    @required this.repository,
    @required this.deleteCategory,
    @required this.reorderCategories
  }) : super(CategoryEmpty()) {
    _categoriesSubscription = repository.categoryListController.stream
      .listen((categories) => add(CategoriesChanged(newCategories: categories)));
  }

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
      int index = this.state.categoryList.indexWhere((element) => element.id == event.categoryID);

      if (index != -1) {
        var newCategory = this.state.categoryList[index].clone(noReadCount: event.newReadCount);
        final newCategories = this.state.categoryList.map(
          (e) => e.id == event.categoryID ? newCategory : e.clone()
        ).toList();

        yield CategoryLoaded(
          categoryList: newCategories
        );
      }
    }
  }
}
