part of 'categoryaction_bloc.dart';

abstract class CategoryActionState extends Equatable {
  const CategoryActionState();
  
  @override
  List<Object> get props => [];
}

class CategoryactionInitial extends CategoryActionState {}
