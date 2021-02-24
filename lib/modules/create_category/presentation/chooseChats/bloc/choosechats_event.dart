part of 'choosechats_bloc.dart';

abstract class ChooseChatsEvent extends Equatable {
  const ChooseChatsEvent();

  @override
  List<Object> get props => [];
}

class ChatChosen extends ChooseChatsEvent{
  final ChatEntity chat;

  ChatChosen(this.chat);

  @override
  List<Object> get props => [chat];
}