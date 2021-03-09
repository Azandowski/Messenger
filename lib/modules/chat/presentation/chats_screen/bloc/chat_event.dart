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
  // TODO: implement props
  List<Object> get props => [message];

}
