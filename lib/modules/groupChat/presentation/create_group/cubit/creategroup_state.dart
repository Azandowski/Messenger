part of 'creategroup_cubit.dart';

abstract class CreateGroupState extends Equatable {
  final List<ContactEntity> contacts;
  final File imageFile;

  const CreateGroupState({
    @required this.contacts,
    @required this.imageFile
  });

  @override
  List<Object> get props => [contacts, imageFile];
}

class CreateGroupNormal extends CreateGroupState {
  final File imageFile;
  final List<ContactEntity> contacts;

  CreateGroupNormal({
    @required this.imageFile,
    @required this.contacts
  }) : super(contacts: contacts, imageFile: imageFile);

  @override
  List<Object> get props => [imageFile, contacts];
}

class CreateGroupLoading extends CreateGroupState {
  final List<ContactEntity> contacts;
  final File imageFile;

  CreateGroupLoading({
    @required this.contacts,
    @required this.imageFile,
  }) : super(contacts: contacts, imageFile: imageFile);
  
  @override
  List<Object> get props => [contacts, imageFile];
}

class CreateGroupContactsLoading extends CreateGroupState {
  final List<ContactEntity> chats;
  final File imageFile;

  CreateGroupContactsLoading({
    @required this.chats,
    @required this.imageFile,
  }) : super(contacts: chats, imageFile: imageFile);
  
  @override
  List<Object> get props => [chats, imageFile];
}

class CreateGroupSuccess extends CreateGroupState {
  final List<ContactEntity> contacts;
  final File imageFile;

  CreateGroupSuccess({
    @required this.contacts,
    @required this.imageFile
  }) : super(contacts: contacts, imageFile: imageFile);

  @override
  List<Object> get props => [imageFile, contacts];
}

class CreateCategoryError extends CreateGroupState {
  final String message;
  final List<ContactEntity> contacts;
  final File imageFile;

  CreateCategoryError ({
    this.message,
    this.contacts,
    this.imageFile
  });

  @override
  List<Object> get props => [message, contacts, imageFile];
}