part of 'create_category_cubit.dart';

abstract class CreateCategoryState extends Equatable {
  final List<ChatEntity> chats;
  final File imageFile;

  const CreateCategoryState({
    @required this.chats,
    @required this.imageFile
  });

  @override
  List<Object> get props => [chats, imageFile];
}


class CreateCategoryNormal extends CreateCategoryState {
  final File imageFile;
  final List<ChatEntity> chats;

  CreateCategoryNormal({
    @required this.imageFile,
    @required this.chats
  }) : super(chats: chats, imageFile: imageFile);

  @override
  List<Object> get props => [imageFile, chats];
}

class CreateCategoryLoading extends CreateCategoryState {
  final List<ChatEntity> chats;
  final File imageFile;

  CreateCategoryLoading({
    @required this.chats,
    @required this.imageFile,
  }) : super(chats: chats, imageFile: imageFile);
  
  @override
  List<Object> get props => [chats, imageFile];
}


class CreateCategorySuccess extends CreateCategoryState {
  final List<CategoryEntity> updatedCategories;
  final List<ChatEntity> chats;
  final File imageFile;

  CreateCategorySuccess({
    @required this.updatedCategories,
    @required this.chats,
    @required this.imageFile
  }) : super(chats: chats, imageFile: imageFile);

  @override
  List<Object> get props => [updatedCategories, imageFile, chats];
}

class CreateCategoryError extends CreateCategoryState {
  final String message;
  final List<ChatEntity> chats;
  final File imageFile;

  CreateCategoryError ({
    this.message,
    this.chats,
    this.imageFile
  });

  @override
  List<Object> get props => [message, chats, imageFile];
}