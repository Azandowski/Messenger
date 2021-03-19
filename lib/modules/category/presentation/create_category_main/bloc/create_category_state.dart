part of 'create_category_cubit.dart';

abstract class CreateCategoryState extends Equatable {
  final List<ChatEntity> chats;
  final File imageFile;
  final bool hasReachMax;

  const CreateCategoryState({
    @required this.chats,
    @required this.imageFile,
    @required this.hasReachMax
  });

  @override
  List<Object> get props => [chats, imageFile, hasReachMax];
}

class CreateCategoryNormal extends CreateCategoryState {
  final File imageFile;
  final List<ChatEntity> chats;
  final bool hasReachMax;

  CreateCategoryNormal({
    @required this.imageFile,
    @required this.chats,
    @required this.hasReachMax
  }) : super(
    chats: chats, 
    imageFile: imageFile,
    hasReachMax: hasReachMax
  );

  @override
  List<Object> get props => [imageFile, chats, hasReachMax];
}

class CreateCategoryLoading extends CreateCategoryState {
  final List<ChatEntity> chats;
  final File imageFile;
  final bool hasReachMax;

  CreateCategoryLoading({
    @required this.chats,
    @required this.imageFile,
    @required this.hasReachMax
  }) : super(
    chats: chats, 
    imageFile: imageFile,
    hasReachMax: hasReachMax
  );
  
  @override
  List<Object> get props => [
    chats, 
    imageFile,
    hasReachMax
  ];
}

class CreateCategoryChatsLoading extends CreateCategoryState {
  final List<ChatEntity> chats;
  final File imageFile;
  final bool hasReachMax;

  CreateCategoryChatsLoading({
    @required this.chats,
    @required this.imageFile,
    @required this.hasReachMax
  }) : super(
    chats: chats, 
    imageFile: imageFile,
    hasReachMax: hasReachMax
  );
  
  @override
  List<Object> get props => [
    chats, 
    imageFile, 
    hasReachMax];
}

// Загрузка при переносе чата в другую категорию
class CreateCategoryTransferLoading extends CreateCategoryState {
  final List<ChatEntity> chats;
  final File imageFile;
  final int categoryID;
  final List<int> chatsIDs;
  final bool hasReachMax;

  CreateCategoryTransferLoading({
    @required this.chats,
    @required this.imageFile,
    @required this.categoryID,
    @required this.chatsIDs,
    @required this.hasReachMax
  }) : super(
    chats: chats, 
    imageFile: imageFile,
    hasReachMax: hasReachMax
  );

  @override
  List<Object> get props => [
    chats, 
    imageFile, 
    categoryID, 
    chatsIDs,
    hasReachMax
  ];
}

class CreateCategorySuccess extends CreateCategoryState {
  final List<CategoryEntity> updatedCategories;
  final List<ChatEntity> chats;
  final File imageFile;
  final bool hasReachMax;

  CreateCategorySuccess({
    @required this.updatedCategories,
    @required this.chats,
    @required this.imageFile,
    @required this.hasReachMax
  }) : super(
    chats: chats, 
    imageFile: imageFile,
    hasReachMax: hasReachMax
  );

  @override
  List<Object> get props => [
    updatedCategories, 
    imageFile, 
    chats,
    hasReachMax
  ];
}

class CreateCategoryError extends CreateCategoryState {
  final String message;
  final List<ChatEntity> chats;
  final File imageFile;
  final bool hasReachMax;

  CreateCategoryError ({
    this.message,
    this.chats,
    this.imageFile,
    this.hasReachMax
  }) : super(
    chats: chats, 
    imageFile: imageFile,
    hasReachMax: hasReachMax
  );

  @override
  List<Object> get props => [message, chats, imageFile, hasReachMax];
}