part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  final List<CategoryEntity> categoryList;

  CategoryState({ @required this.categoryList});

  @override
  List<Object> get props => [categoryList];
}

class CategoryEmpty extends CategoryState {}

class CategoryLoaded extends CategoryState{
  final List<CategoryEntity> categoryList;

  CategoryLoaded({@required this.categoryList}) : super(categoryList: categoryList);

  @override
  List<Object> get props => [categoryList];
}

class CategoriesUpdating extends CategoryState{
  final List<CategoryEntity> categoryList;

  CategoriesUpdating({@required this.categoryList}) : super(categoryList: categoryList);
}

class CategoriesErrorHappened extends CategoryState{
  final List<CategoryEntity> categoryList;
  final String message;

  CategoriesErrorHappened({@required this.categoryList,@required this.message}) : super(categoryList: categoryList);
}