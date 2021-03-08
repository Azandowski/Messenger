part of 'chat_details_cubit.dart';

abstract class ChatDetailsState extends Equatable {
  final ChatDetailed chatDetailed;
  
  const ChatDetailsState({
    @required this.chatDetailed
  });

  ChatDetailsState copyWith ({
    ChatDetailed chatDetailed
  });

  @override
  List<Object> get props => [chatDetailed];
}

class ChatDetailsLoading extends ChatDetailsState {
  
  @override
  ChatDetailsState copyWith({ChatDetailed chatDetailed}) {
    return ChatDetailsLoading();
  }
}

class ChatDetailsLoaded extends ChatDetailsState {
  final ChatDetailed chatDetailed;

  ChatDetailsLoaded({
    @required this.chatDetailed
  }) : super(chatDetailed: chatDetailed);

  @override
  List<Object> get props => [
    chatDetailed
  ];

  @override
  ChatDetailsState copyWith({
    ChatDetailed chatDetailed
  }) {
    return ChatDetailsLoaded(
      chatDetailed: chatDetailed ?? this.chatDetailed
    );
  }
}

class ChatDetailsError extends ChatDetailsState {
  final ChatDetailed chatDetailed;
  final String message;

  ChatDetailsError({
    @required this.chatDetailed,
    @required this.message
  }) : super(chatDetailed: chatDetailed);

  @override
  List<Object> get props => [
    chatDetailed, 
    message
  ];

  @override
  ChatDetailsState copyWith({
    ChatDetailed chatDetailed
  }) {
    return ChatDetailsError(
      message: this.message,
      chatDetailed: chatDetailed ?? this.chatDetailed
    );
  }
}



