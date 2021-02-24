part of 'choosechats_bloc.dart';

abstract class ChooseChatsState extends Equatable {
  const ChooseChatsState();

  @override
  List<Object> get props => [];
}

class ChoosechatsInitial extends ChooseChatsState {}

class ChooseChatLoading extends ChooseChatsState {}

class ChooseChatsLoaded extends ChooseChatsState {
  final List<ChatEntity> chatEntities;

  ChooseChatsLoaded({@required this.chatEntities});
}
