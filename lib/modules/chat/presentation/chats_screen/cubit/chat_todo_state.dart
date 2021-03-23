part of 'chat_todo_cubit.dart';

abstract class ChatTodoState extends Equatable {
  final List<Message> selectedMessages;
  final bool isDelete;
  const ChatTodoState({
    @required this.selectedMessages,
    @required this.isDelete,
  });

  @override
  List<Object> get props => [selectedMessages, isDelete];
}

class ChatTodoSelection extends ChatTodoState {
  final List<Message> selectedMessages;

  //isDelete = true, если false то переслать всем
  final bool isDelete;

  ChatTodoSelection({
    this.selectedMessages,
    @required this.isDelete,
  }) : super(selectedMessages: selectedMessages, isDelete: isDelete); 

  @override
  List<Object> get props => [selectedMessages, isDelete];
}

class ChatToDoDisabled extends ChatTodoState{}

class ChatToDoLoading extends ChatTodoState{
 final List<Message> selectedMessages;
 final bool isDelete;

  ChatToDoLoading({
    this.selectedMessages,
    this.isDelete
  }) : super(selectedMessages: selectedMessages, isDelete: isDelete ?? false); 

  @override
  List<Object> get props => [selectedMessages, isDelete];
}

class ChatToDoError extends ChatTodoState{

 final List<Message> selectedMessages;
 final bool isDelete;
 final String errorMessage;

  ChatToDoError({
    @required this.errorMessage,
    this.selectedMessages,
    this.isDelete
  }) : super(selectedMessages: selectedMessages, isDelete: isDelete ?? false); 

  @override
  List<Object> get props => [selectedMessages, isDelete, errorMessage];

}