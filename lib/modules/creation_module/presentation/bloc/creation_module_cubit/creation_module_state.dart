part of 'creation_module_cubit.dart';

abstract class CreationModuleState extends Equatable {
  const CreationModuleState();

  @override
  List<Object> get props => [];
}

class CreationModuleLoading extends CreationModuleState {}

class CreationModuleInitial extends CreationModuleState {}

class CreationModuleError extends CreationModuleState {
  final String message;

  CreationModuleError({
    @required this.message
  });
}

class OpenChatWithUser extends CreationModuleState {
  final ChatEntity newChat;

  OpenChatWithUser({@required this.newChat});
}