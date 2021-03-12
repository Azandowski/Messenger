import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/utils/paginated_scroll_controller.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_messages.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/send_message.dart';
import 'package:messenger_mobile/core/utils/list_helper.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {

  final ChatRepository chatRepository;
  final SendMessage sendMessage;
  final GetMessages getMessages;
  final int chatId;

  var _random = Random();
  
  PaginatedScrollController scrollController = PaginatedScrollController(
    isReversed: true
  );

  ChatBloc({
    @required this.chatRepository,
    @required this.chatId,
    @required this.sendMessage,
    @required this.getMessages
  }) : super(
    ChatInitial(
      messages: [],
      hasReachedMax: false
    )
  ) {
    _chatSubscription = chatRepository.message.listen(
      (message) {
        add(MessageAdded(message: message));
      }
    );

    scrollController.addListener(() {
      if (scrollController.isPaginated && !(state is ChatLoading) && !state.hasReachedMax) {
        // Load More
        
        this.add(LoadMessages(
          isPagination: true
        ));
      }
    });
  }
 
  StreamSubscription<Message> _chatSubscription;


  // * * Main

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is MessageAdded) {
      var list = getCopyMessages();
      
      var i = list.indexWhere((element) => element.identificator == event.message.id);
      
      if (i != -1) {
        list.removeAt(i);
      }

      list.insert(0, event.message);
      
      yield ChatInitial(
        messages: list,
        hasReachedMax: this.state.hasReachedMax
      );
    } else if (event is MessageSend) {
      var list = getCopyMessages();
      int randomID = _random.nextInt(99999);
      
      var newMessage = Message(
        user: MessageUser(
          id: sl<AuthConfig>().user.id,
        ),
        transfer: event.forwardMessage!= null ? [event.forwardMessage] : [],
        text: event.message,
        identificator: randomID,
        isRead: false,
        messageStatus: MessageStatus.sending,
      );
      
      list.insert(0, newMessage);    

      yield ChatInitial(
        messages: list,
        hasReachedMax: this.state.hasReachedMax
      );
      List<int> forwardArray = [];
      if(event.forwardMessage != null){
        forwardArray.add(event.forwardMessage.id);
      }

      final response = await sendMessage(SendMessageParams(
        chatID: chatId,
        text: event.message,
        identificator: randomID,
        forwardIds: forwardArray,
      ));

      yield* _eitherSentOrErrorState(response);
    } else if (event is LoadMessages) {
      yield ChatLoading(
        isPagination: event.isPagination,
        messages: this.state.messages,
        hasReachedMax: this.state.hasReachedMax
      );

      final response = await getMessages(event.isPagination ? this.state.messages?.lastItem?.id : null);

      yield* _eitherMessagesOrErrorState(response, event.isPagination);
    }
  }

  Stream<ChatState> _eitherSentOrErrorState(
    Either<Failure, Message> failureOrMessage,
  ) async* {
    var list = getCopyMessages();
    
    yield failureOrMessage.fold(
      (failure) => ChatInitial(
        messages: list,
        hasReachedMax: this.state.hasReachedMax
      ),
      (message) {
        var i = list.indexWhere((element) => element.identificator == message.identificator);
        list[i]= message.copyWith(identificator: message.id);
        return ChatInitial(
          messages: list,
          hasReachedMax: this.state.hasReachedMax
        );
      }
    );
  }
  
  Stream<ChatState> _eitherMessagesOrErrorState (
    Either<Failure, PaginatedResultViaLastItem<Message>> failureOrMessage,
    bool isPagination
  ) async* {
    yield failureOrMessage.fold(
      (failure) => ChatError(
        messages: this.state.messages, 
        message: failure.message,
        hasReachedMax: this.state.hasReachedMax
      ),
      (result) {
        List<Message> newMessages = isPagination ? 
          (this.state.messages ?? []) + result.data : result.data;
        
        return ChatInitial(
          messages: newMessages,
          hasReachedMax: result.hasReachMax
        );
      }
    );
  }

  List<Message> getCopyMessages() => state.messages.map((e) => e.copyWith()).toList();
}
