part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoriesChanged extends CategoryEvent{
  final List<CategoryEntity> newCategories;

  CategoriesChanged({
    @required this.newCategories
  });

  @override
  List<Object> get props => [newCategories];
}

class CategoryRemoving extends CategoryEvent{
  final int categoryId;

  CategoryRemoving({
    this.categoryId
  });

  @override
  List<Object> get props => [categoryId];
}

class CategoriesReset extends CategoryEvent {}

class CategoriesReordered extends CategoryEvent {
  final Map<String, int> categoryUpdated;

  CategoriesReordered({
    @required this.categoryUpdated
  });

  @override
  List<Object> get props => [
    categoryUpdated
  ];
}

class CategoryReadCountChanged extends CategoryEvent {
  final int categoryID;
  final int newReadCount;

  CategoryReadCountChanged({
    @required this.categoryID,
    @required this.newReadCount
  });

  @override
  List<Object> get props => [
    categoryID, newReadCount
  ];
}