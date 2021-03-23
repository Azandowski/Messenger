part of 'chat_select_cubit.dart';

abstract class ChatSelectState extends Equatable {
  ChatSelectState({this.selectedChats});

  final List<ChatEntity> selectedChats;

  @override
  List<Object> get props => [selectedChats];
}

class ChatSelectInitial extends ChatSelectState {
  ChatSelectInitial({
    this.selectedChats
  }) : super(selectedChats: selectedChats);

  final List<ChatEntity> selectedChats;

  @override
  List<Object> get props => [
    selectedChats
  ];
}
