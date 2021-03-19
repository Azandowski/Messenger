import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';
import 'package:messenger_mobile/modules/chat/data/datasources/chat_datasource.dart';
import 'package:messenger_mobile/modules/chat/data/models/chat_message_response.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_actions.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_messages_context.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../../../../../core/config/auth_config.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
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
    @required this.getMessagesContext,
    bool isSecretModeOn,
    ChatEntity chatEntity
  }) : super(
    ChatLoading(
      messages: [],
      hasReachedMax: false,
      isPagination: false,
      isSecretModeOn: isSecretModeOn,
      chatEntity: chatEntity
    )
  ) {
    this.add(ChatScreenStarted());

    _chatSubscription = chatRepository.message.listen(
      (message) {
        if (message.chatActions == ChatActions.setSecret) {
          add(SetInitialTime(isOn: true));
        } else if (message.chatActions == ChatActions.unsetSecret) {
          add(SetInitialTime(isOn: false));
        }

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
          showBottomPin: state.showBottomPin,
          isSecretModeOn: state.isSecretModeOn,
          chatEntity: state.chatEntity
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
        showBottomPin: state.showBottomPin,
        isSecretModeOn: state.isSecretModeOn,
        chatEntity: state.chatEntity
      );

      final response = await setTimeDeleted(SetTimeDeletedParams(
        id: chatId, 
        isOn: event.isOn
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
        isSecretModeOn: state.isSecretModeOn,
        chatEntity: state.chatEntity
      );
    } else if (event is PermissionsUpdated) {
      yield state.copyWith(chatEntity: state.chatEntity.clone(permissions: event.newPermissions));
    }
  }

  Stream<ChatState> _eitherSentOrErrorState(
    Either<Failure, Message> failureOrMessage,
    int identificator
  ) async* {
    var list = getCopyMessages();    
    yield failureOrMessage.fold(
      (failure) {
        var i = list.indexWhere((element) => element.identificator == identificator);
        list.removeAt(i);
        return ChatError(
          messages: list,
          hasReachedMax: this.state.hasReachedMax,
          wallpaperPath: this.state.wallpaperPath,
          hasReachBottomMax: this.state.hasReachBottomMax,
          unreadCount: state.unreadCount,
          showBottomPin: state.showBottomPin,
          isSecretModeOn: state.isSecretModeOn,
          message: failure.message,
          chatEntity: state.chatEntity
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
          showBottomPin: state.showBottomPin,
          isSecretModeOn: state.isSecretModeOn,
          chatEntity: state.chatEntity
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
        showBottomPin: state.showBottomPin,
        isSecretModeOn: state.isSecretModeOn,
        chatEntity: state.chatEntity
      ),
      (result) {
        List<Message> newMessages = isPagination ? direction == RequestDirection.top ? 
          ((this.state.messages ?? []) + result.result.data) : result.result.data + (state.messages ?? []) : result.result.data;
        
        bool hasReachBottom;
        if (focusMessageID != null) {
          hasReachBottom =  false;
        } else if (direction == RequestDirection.bottom) {
          hasReachBottom = result.result.hasReachMax;
        } else {
          hasReachBottom = direction != RequestDirection.bottom  ?
            state.hasReachBottomMax : result.result.hasReachMax;
        }

        return ChatInitial(
          topMessage: result.topMessage,
          messages: newMessages,
          hasReachedMax: isPagination && direction != RequestDirection.top ? 
            state.hasReachedMax : result.result.hasReachMax,
          wallpaperPath: this.state.wallpaperPath,
          hasReachBottomMax: hasReachBottom,
          focusMessageID: focusMessageID,
          unreadCount: hasReachBottom ? null : state.unreadCount,
          showBottomPin: state.showBottomPin,
          isSecretModeOn: state.isSecretModeOn,
          chatEntity: state.chatEntity
        );
      }
    );
  }

  Stream<ChatState> _messageAddedToState(MessageAdded event) async* {
    switch(event.message.messageHandleType) {
      case MessageHandleType.newMessage:
        if (state.hasReachBottomMax) {
          var list = getCopyMessages();
          var i = list.indexWhere((e) => e.identificator == event.message.id);
          
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
            isSecretModeOn: state.isSecretModeOn,
            chatEntity: state.chatEntity
          );
        } else {
          yield ChatInitial (
            messages: state.messages,
            hasReachedMax: this.state.hasReachedMax,
            wallpaperPath: this.state.wallpaperPath,
            hasReachBottomMax: this.state.hasReachBottomMax,
            unreadCount: (state.unreadCount ?? 0) + 1,
            showBottomPin: state.showBottomPin,
            isSecretModeOn: state.isSecretModeOn,
            chatEntity: state.chatEntity
          );
        }
        break;
      case MessageHandleType.setTopMessage:
        yield ChatInitial(
          topMessage: event.message,
          messages: this.state.messages,
          hasReachedMax: this.state.hasReachedMax,
          wallpaperPath: this.state.wallpaperPath,
          hasReachBottomMax: this.state.hasReachBottomMax,
          isSecretModeOn: state.isSecretModeOn
        );
        break;
      case MessageHandleType.unSetTopMessage:
         yield ChatInitial(
          topMessage: null,
          messages: this.state.messages,
          hasReachedMax: this.state.hasReachedMax,
          wallpaperPath: this.state.wallpaperPath,
          hasReachBottomMax: this.state.hasReachBottomMax,
          isSecretModeOn: state.isSecretModeOn,
          chatEntity: state.chatEntity
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
        unreadCount: state.unreadCount,
        isSecretModeOn: state.isSecretModeOn,
        chatEntity: state.chatEntity
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
      showBottomPin: state.showBottomPin,
      isSecretModeOn: state.isSecretModeOn,
      chatEntity: state.chatEntity
    );
    
    List<int> forwardArray = [];
    if (event.forwardMessage != null){
      forwardArray.add(event.forwardMessage.id);
    }

    final response = await sendMessage(SendMessageParams(
      chatID: chatId,
      text: event.message,
      identificator: randomID,
      forwardIds: forwardArray,
      timeLeft: event.timeDeleted
    ));

    yield* _eitherSentOrErrorState(response, randomID);
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
      showBottomPin: state.showBottomPin,
      isSecretModeOn: state.isSecretModeOn,
      chatEntity: state.chatEntity
    );
  }

  // * * Time Deletion

  Stream<ChatState> _eitherSentWithTimerOrFailure(
    Either<Failure, ChatPermissions> failureOrNoParams,
    SetInitialTime event
  ) async* {
    yield failureOrNoParams.fold(
      (failure) => ChatError(
        topMessage: this.state.topMessage,
        messages: this.state.messages,
        hasReachedMax: this.state.hasReachedMax,
        wallpaperPath: this.state.wallpaperPath,
        hasReachBottomMax: this.state.hasReachBottomMax,
        unreadCount: state.unreadCount,
        showBottomPin: state.showBottomPin,
        isSecretModeOn: state.isSecretModeOn,
        message: failure.message,
        chatEntity: state.chatEntity
      ),
      (response) {
        // _handleTimerNewValue(event);
        return ChatInitial(
          topMessage: this.state.topMessage,
          messages: this.state.messages,
          hasReachedMax: this.state.hasReachedMax,
          wallpaperPath: this.state.wallpaperPath,
          hasReachBottomMax: this.state.hasReachBottomMax,
          unreadCount: state.unreadCount,
          showBottomPin: state.showBottomPin,
          isSecretModeOn: response.isSecret,
          chatEntity: state.chatEntity
        );
      }
    );
  }


  List<Message> getCopyMessages() => state.messages.map((e) => e.copyWith()).toList();
}
