part of 'create_category_cubit.dart';

abstract class CreateCategoryState extends Equatable {
  const CreateCategoryState();

  @override
  List<Object> get props => [];
}


class CreateCategoryNormal extends CreateCategoryState {
  final File imageFile;
  final List<ChatEntity> chats;

  CreateCategoryNormal({
    @required this.imageFile,
    @required this.chats
  });

  @override
  List<Object> get props => [imageFile, chats];
}

class CreateCategoryLoading extends CreateCategoryState {}

class CreateCategorySuccess extends CreateCategoryState {
  final List<CategoryEntity> updatedCategories;

  CreateCategorySuccess({
    @required this.updatedCategories
  });

  @override
  List<Object> get props => [updatedCategories];
}

class CreateCategoryError extends CreateCategoryState {
  final String message;

  CreateCategoryError ({
    this.message
  });

  @override
  List<Object> get props => [message];
}