part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
  
  @override
  List<Object> get props => [];
}

class CategoryEmpty extends CategoryState {}

class CategoryLoaded extends CategoryState{
  final List<CategoryEntity> categoryList;

  CategoryLoaded({ @required this.categoryList});

  @override
  List<Object> get props => [categoryList];
}