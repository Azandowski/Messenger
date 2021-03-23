import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../../../../../core/config/auth_config.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/list_helper.dart';
import '../../../../../locator.dart';
import '../../../../chats/domain/repositories/chats_repository.dart';
import '../../../data/datasources/chat_datasource.dart';
import '../../../data/models/chat_message_response.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../domain/usecases/get_messages.dart';
import '../../../domain/usecases/get_messages_context.dart';
import '../../../domain/usecases/params.dart';
import '../../../domain/usecases/send_message.dart';
import '../../../domain/usecases/set_time_deleted.dart';
import '../../time_picker/time_picker_screen.dart';
import '../pages/chat_screen_import.dart';

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

    _chatDeleteSubscription = chatRepository.deleteIds.listen(
      (ids) {
        add(MessageDelete(ids: ids));
      }
    );
  }
 
  StreamSubscription<Message> _chatSubscription;

  StreamSubscription<List<int>> _chatDeleteSubscription;



  // * * Main

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ChatScreenStarted) {
      yield* _chatInitialEventToState();
    } else if (event is MessageAdded) {
      yield* _messageAddedToState(event);
    } else if (event is MessageSend) {
      yield* _messageSendToState(event);
    } else if (event is MessageDelete) {
      yield* _messageDeleteToState(event);
    } else if (event is LoadMessages) {
      
      if (this.state.hasReachBottomMax && event.resetAll) {
        scrollController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.bounceInOut);
      } else {
        yield ChatLoading(
          isPagination: event.isPagination,
          messages: event.resetAll ? [] : this.state.messages,
          hasReachedMax: event.resetAll ? false : this.state.hasReachedMax,
          hasReachBottomMax: event.resetAll ? false : this.state.hasReachBottomMax,
          wallpaperPath: this.state.wallpaperPath,
          direction: event.resetAll ? null : event.direction,
          unreadCount: event.resetAll ? null : state.unreadCount,
          showBottomPin: state.showBottomPin
        );

        Either<Failure, ChatMessageResponse> response;
        
        if (event.messageID != null) {
          response = await getMessagesContext(GetMessagesContextParams(
            chatID: chatId, 
            messageID: event.messageID
          ));
        } else {
          response = await getMessages(GetMessagesParams(
            lastMessageId: event.isPagination ? 
              event.direction == null || event.direction == RequestDirection.top ?
                this.state.messages?.lastItem?.id : 
                this.state.messages.getItemAt(0)?.id 
              : null, 
            direction: event.direction
          ));
        }

        yield* _eitherMessagesOrErrorState(
          response, 
          event.isPagination, 
          event.direction,
          event.messageID
        );
      }
    } else if (event is SetInitialTime) {
      yield ChatLoadingSilently(
        topMessage: this.state.topMessage,
        messages: this.state.messages, 
        hasReachedMax: this.state.hasReachedMax, 
        wallpaperPath: this.state.wallpaperPath,
        hasReachBottomMax: this.state.hasReachBottomMax,
        unreadCount: state.unreadCount,
        showBottomPin: state.showBottomPin
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
    } else if (event is ToggleBottomPin) {
      yield ChatInitial(
        wallpaperPath: state.wallpaperPath,
        hasReachedMax: state.hasReachedMax,
        hasReachBottomMax: state.hasReachBottomMax,
        unreadCount: event.newUnreadCount ?? state.unreadCount,
        messages: state.messages,
        showBottomPin: event.show,
      );
    }
  }

  Stream<ChatState> _eitherSentOrErrorState(
    Either<Failure, Message> failureOrMessage,
  ) async* {
    var list = getCopyMessages();    
    yield failureOrMessage.fold(
      (failure) { 
        print('error');
        print(failure.message);
        return ChatInitial(
          messages: list,
          hasReachedMax: this.state.hasReachedMax,
          wallpaperPath: this.state.wallpaperPath,
          hasReachBottomMax: this.state.hasReachBottomMax,
          unreadCount: state.unreadCount,
          showBottomPin: state.showBottomPin
        );
      },
      (message) {
        var i = list.indexWhere((element) => element.identificator == message.identificator);
        list[i]= message.copyWith(
          identificator: message.id,
          status: list[i].messageStatus,
        );
        return ChatInitial(
          topMessage: this.state.topMessage,
          messages: list,
          hasReachedMax: this.state.hasReachedMax,
          wallpaperPath: this.state.wallpaperPath,
          hasReachBottomMax: this.state.hasReachBottomMax,
          unreadCount: state.unreadCount,
          showBottomPin: state.showBottomPin
        );
      }
    );
  }
  
  Stream<ChatState> _eitherMessagesOrErrorState (
    Either<Failure, ChatMessageResponse> failureOrMessage,
    bool isPagination,
    RequestDirection direction,
    int focusMessageID
  ) async* {
    yield failureOrMessage.fold(
      (failure) => ChatError(
        topMessage: this.state.topMessage,
        messages: this.state.messages, 
        message: failure.message,
        hasReachedMax: this.state.hasReachedMax,
        hasReachBottomMax: this.state.hasReachBottomMax,
        wallpaperPath: this.state.wallpaperPath,
        unreadCount: state.unreadCount,
        showBottomPin: state.showBottomPin
      ),
      (result) {
        List<Message> newMessages = isPagination ? direction == RequestDirection.top ? 
          ((this.state.messages ?? []) + result.result.data) : result.result.data + (state.messages ?? []) : result.result.data;
        
        bool hasReachBottom = direction != RequestDirection.bottom ? 
          state.hasReachBottomMax : result.result.hasReachMax;

        return ChatInitial(
          topMessage: result.topMessage,
          messages: newMessages,
          hasReachedMax: isPagination && direction != RequestDirection.top ? 
            state.hasReachedMax : result.result.hasReachMax,
          wallpaperPath: this.state.wallpaperPath,
          hasReachBottomMax: hasReachBottom,
          focusMessageID: focusMessageID,
          unreadCount: hasReachBottom ? null : state.unreadCount,
          showBottomPin: state.showBottomPin
        );
      }
    );
  }

  Stream<ChatState> _messageAddedToState(MessageAdded event) async* {
    switch(event.message.messageHandleType){
      case MessageHandleType.newMessage:
        if (state.hasReachBottomMax) {
          var list = getCopyMessages();
          var i = list.indexWhere((element) => element.identificator == event.message.id);
          
          if (i != -1) {
            list.removeAt(i);
          }

          list.insert(0, event.message);
          
          bool didNotRead = 
            scrollController.offset > scrollController.position.viewportDimension * 1.5;

          yield ChatInitial(
            messages: list,
            hasReachedMax: this.state.hasReachedMax,
            wallpaperPath: this.state.wallpaperPath,
            hasReachBottomMax: this.state.hasReachBottomMax,
            unreadCount: didNotRead ? (state.unreadCount ?? 0) + 1 : state.unreadCount,
            showBottomPin: state.showBottomPin,
          );
        } else {
          yield ChatInitial (
            messages: state.messages,
            hasReachedMax: this.state.hasReachedMax,
            wallpaperPath: this.state.wallpaperPath,
            hasReachBottomMax: this.state.hasReachBottomMax,
            unreadCount: (state.unreadCount ?? 0) + 1,
            showBottomPin: state.showBottomPin
          );
        }
        break;
      case MessageHandleType.setTopMessage:
        yield ChatInitial(
          topMessage: event.message,
          messages: this.state.messages,
          hasReachedMax: this.state.hasReachedMax,
          wallpaperPath: this.state.wallpaperPath,
          hasReachBottomMax: this.state.hasReachBottomMax
        );
        break;
      case MessageHandleType.unSetTopMessage:
         yield ChatInitial(
          topMessage: null,
          messages: this.state.messages,
          hasReachedMax: this.state.hasReachedMax,
          wallpaperPath: this.state.wallpaperPath,
          hasReachBottomMax: this.state.hasReachBottomMax
        );
        break;
    }
  }

  Stream<ChatState> _chatInitialEventToState() async* {
    File wallpaperFile = await chatsRepository.getLocalWallpaper();
    if (wallpaperFile != null) {
      yield ChatInitial(
        topMessage: this.state.topMessage,
        messages: this.state.messages,
        hasReachedMax: this.state.hasReachedMax,
        wallpaperPath: wallpaperFile.path,
        hasReachBottomMax: this.state.hasReachBottomMax,
        unreadCount: state.unreadCount
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
      topMessage: this.state.topMessage,
      messages: list,
      hasReachedMax: this.state.hasReachedMax,
      wallpaperPath: this.state.wallpaperPath,
      hasReachBottomMax: this.state.hasReachBottomMax,
      unreadCount: state.unreadCount,
      showBottomPin: state.showBottomPin
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
      fieldFiles: event.fieldFiles,
    ));

    yield* _eitherSentOrErrorState(response);
  }

  Stream<ChatState> _messageDeleteToState(MessageDelete event) async* {
    var list = getCopyMessages(); 

    event.ids.forEach((id) { 
      list.removeWhere((message) => message.id == id);
    });

    yield ChatInitial(
      topMessage: this.state.topMessage,
      messages: list,
      hasReachedMax: this.state.hasReachedMax,
      wallpaperPath: this.state.wallpaperPath,
      unreadCount: state.unreadCount,
      showBottomPin: state.showBottomPin
    );
  }

  // * * Time Deletion

  Stream<ChatState> _eitherSentWithTimerOrFailure(
    Either<Failure, NoParams> failureOrNoParams,
    SetInitialTime event
  ) async* {
    yield failureOrNoParams.fold(
      (failure) => ChatInitial(
        topMessage: this.state.topMessage,
        messages: this.state.messages,
        hasReachedMax: this.state.hasReachedMax,
        wallpaperPath: this.state.wallpaperPath,
        hasReachBottomMax: this.state.hasReachBottomMax,
        unreadCount: state.unreadCount,
        showBottomPin: state.showBottomPin
      ),
      (_) {
        _handleTimerNewValue(event);
        return ChatInitial(
          topMessage: this.state.topMessage,
          messages: this.state.messages,
          hasReachedMax: this.state.hasReachedMax,
          wallpaperPath: this.state.wallpaperPath,
          hasReachBottomMax: this.state.hasReachBottomMax,
          unreadCount: state.unreadCount,
          showBottomPin: state.showBottomPin
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
