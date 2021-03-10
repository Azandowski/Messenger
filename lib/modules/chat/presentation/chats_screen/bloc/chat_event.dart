part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  
  const ChatEvent();
}

class MessageAdded extends ChatEvent{
  final Message message;

  MessageAdded({
   @required this.message
  });

  @override
  List<Object> get props => [message];

}

class MessageSend extends ChatEvent{
  final String message;

  MessageSend({this.message});

  @override
  List<Object> get props => [message];
  
}
