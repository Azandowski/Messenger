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