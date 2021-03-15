import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/chat/data/datasources/chat_datasource.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_messages_context.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../../../../../core/config/auth_config.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/services/network/paginatedResult.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/paginated_scroll_controller.dart';
import '../../../../../locator.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../domain/usecases/get_messages.dart';
import '../../../domain/usecases/params.dart';
import '../../../domain/usecases/send_message.dart';
import '../../../../../core/utils/list_helper.dart';
import '../../../domain/usecases/set_time_deleted.dart';
import '../../time_picker/time_picker_screen.dart';
import '../../../../chats/domain/repositories/chats_repository.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  
  final ChatsRepository chatsRepository;
  final ChatRepository chatRepository;
  final SendMessage sendMessage;
  final GetMessages getMessages;
  final GetMessagesContext getMessagesContext;
  final SetTimeDeleted setTimeDeleted;
  final int chatId;

  var _random = Random();
  
  AutoScrollController scrollController = AutoScrollController();

  // Timer left for the messages
  int currentLeftTime = 0;
  Timer _timerDeletion;


  ChatBloc({
    @required this.chatRepository,
    @required this.chatsRepository,
    @required this.chatId,
    @required this.sendMessage,
    @required this.getMessages,
    @required this.setTimeDeleted,
    @required this.getMessagesContext
  }) : super(
    ChatLoading(
      messages: [],
      hasReachedMax: false,
      isPagination: false
    )
  ) {
    this.add(ChatScreenStarted());

    _chatSubscription = chatRepository.message.listen(
      (message) {
        add(MessageAdded(message: message));
      }
    );
  }
 
  StreamSubscription<Message> _chatSubscription;

  // * * Main

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ChatScreenStarted) {
      yield* _chatInitialEventToState();
    } else if (event is MessageAdded) {
      yield* _messageAddedToState(event);
    } else if (event is MessageSend) {
      yield* _messageSendToState(event);
    } else if (event is LoadMessages) {
      yield ChatLoading(
        isPagination: event.isPagination,
        messages: this.state.messages,
        hasReachedMax: this.state.hasReachedMax,
        hasReachBottomMax: this.state.hasReachBottomMax,
        wallpaperPath: this.state.wallpaperPath,
      );

      Either<Failure, PaginatedResultViaLastItem<Message>> response;
      
      if (event.messageID != null) {
        response = await getMessagesContext(GetMessagesContextParams(
          chatID: chatId, 
          messageID: event.messageID
        ));
      } else {
        response = await getMessages(GetMessagesParams(
          lastMessageId: event.isPagination ? this.state.messages?.lastItem?.id : null, 
          direction: event.direction
        ));
      }

      yield* _eitherMessagesOrErrorState(
        response, 
        event.isPagination, 
        event.direction,
        event.messageID
      );
    } else if (event is SetInitialTime) {
      yield ChatLoadingSilently(
        messages: this.state.messages, 
        hasReachedMax: this.state.hasReachedMax, 
        wallpaperPath: this.state.wallpaperPath,
        hasReachBottomMax: this.state.hasReachBottomMax,
      );

      final response = await setTimeDeleted(SetTimeDeletedParams(
        id: chatId, 
        seconds: event.option.seconds
      ));

      yield* _eitherSentWithTimerOrFailure(response, event);
      // TODO: Update it
      currentLeftTime = 10;
    } else if (event is DisposeChat) {
      await chatRepository.disposeChat();
    } 
  }

  Stream<ChatState> _eitherSentOrErrorState(
    Either<Failure, Message> failureOrMessage,
  ) async* {
    var list = getCopyMessages();    
    yield failureOrMessage.fold(
      (failure) => ChatInitial(
        messages: list,
        hasReachedMax: this.state.hasReachedMax,
        wallpaperPath: this.state.wallpaperPath,
        hasReachBottomMax: this.state.hasReachBottomMax,
      ),
      (message) {
        var i = list.indexWhere((element) => element.identificator == message.identificator);
        list[i]= message.copyWith(
          identificator: message.id,
          status: list[i].messageStatus,
        );
        return ChatInitial(
          messages: list,
          hasReachedMax: this.state.hasReachedMax,
          wallpaperPath: this.state.wallpaperPath,
          hasReachBottomMax: this.state.hasReachBottomMax,
        );
      }
    );
  }
  
  Stream<ChatState> _eitherMessagesOrErrorState (
    Either<Failure, PaginatedResultViaLastItem<Message>> failureOrMessage,
    bool isPagination,
    RequestDirection direction,
    int focusMessageID
  ) async* {
    yield failureOrMessage.fold(
      (failure) => ChatError(
        messages: this.state.messages, 
        message: failure.message,
        hasReachedMax: this.state.hasReachedMax,
        hasReachBottomMax: this.state.hasReachBottomMax,
        wallpaperPath: this.state.wallpaperPath
      ),
      (result) {
        List<Message> newMessages = isPagination ? direction == RequestDirection.top ? 
          ((this.state.messages ?? []) + result.data) : result.data + (state.messages ?? []) : result.data;
        
        return ChatInitial(
          messages: newMessages,
          hasReachedMax: isPagination && direction != RequestDirection.top ? 
            state.hasReachedMax : result.hasReachMax,
          wallpaperPath: this.state.wallpaperPath,
          hasReachBottomMax: isPagination && direction != RequestDirection.bottom ? 
            state.hasReachBottomMax : result.hasReachMaxSecondSide,
          focusMessageID: focusMessageID
        );
      }
    );
  }

  Stream<ChatState> _messageAddedToState(MessageAdded event) async* {
    var list = getCopyMessages();
      
    var i = list.indexWhere((element) => element.identificator == event.message.id);
    
    if (i != -1) {
      list.removeAt(i);
    }

    list.insert(0, event.message);
    
    yield ChatInitial(
      messages: list,
      hasReachedMax: this.state.hasReachedMax,
      wallpaperPath: this.state.wallpaperPath,
      hasReachBottomMax: this.state.hasReachBottomMax
    );
  }

  Stream<ChatState> _chatInitialEventToState() async* {
    File wallpaperFile = await chatsRepository.getLocalWallpaper();
    if (wallpaperFile != null) {
      yield ChatInitial(
        messages: this.state.messages,
        hasReachedMax: this.state.hasReachedMax,
        wallpaperPath: wallpaperFile.path,
        hasReachBottomMax: this.state.hasReachBottomMax,
      );
    }
  }

  Stream<ChatState> _messageSendToState(MessageSend event) async* {
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
      hasReachedMax: this.state.hasReachedMax,
      wallpaperPath: this.state.wallpaperPath,
      hasReachBottomMax: this.state.hasReachBottomMax,
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
  }

  // * * Time Deletion

  Stream<ChatState> _eitherSentWithTimerOrFailure(
    Either<Failure, NoParams> failureOrNoParams,
    SetInitialTime event
  ) async* {
    yield failureOrNoParams.fold(
      (failure) => ChatInitial(
        messages: this.state.messages,
        hasReachedMax: this.state.hasReachedMax,
        wallpaperPath: this.state.wallpaperPath,
        hasReachBottomMax: this.state.hasReachBottomMax,
      ),
      (_) {
        _handleTimerNewValue(event);
        return ChatInitial(
          messages: this.state.messages,
          hasReachedMax: this.state.hasReachedMax,
          wallpaperPath: this.state.wallpaperPath,
          hasReachBottomMax: this.state.hasReachBottomMax,
        );
      }
    );
  }


  void _handleTimerNewValue (SetInitialTime event) {
    currentLeftTime = event.option.seconds;
  
    if (currentLeftTime == null || currentLeftTime == 0) {
      _timerDeletion.cancel();
    } else {
      _timerDeletion = new Timer.periodic(
      Duration(seconds: 1), 
      (Timer t) { 
        currentLeftTime -= 1;
        if (currentLeftTime == 0) {
          _timerDeletion.cancel();
        }
      });
    }
  }

  List<Message> getCopyMessages() => state.messages.map((e) => e.copyWith()).toList();
}
