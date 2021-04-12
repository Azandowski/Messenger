import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/application.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/delete_messages.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/file_media.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_media_block.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../../../../../core/config/auth_config.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/list_helper.dart';
import '../../../../../locator.dart';
import '../../../../category/domain/entities/chat_permissions.dart';
import '../../../../chats/domain/repositories/chats_repository.dart';
import '../../../data/datasources/chat_datasource.dart';
import '../../../data/models/chat_message_response.dart';
import '../../../domain/entities/chat_actions.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../domain/usecases/get_messages.dart';
import '../../../domain/usecases/get_messages_context.dart';
import '../../../domain/usecases/params.dart';
import '../../../domain/usecases/send_message.dart';
import '../../../domain/usecases/set_time_deleted.dart';
import '../pages/chat_screen_import.dart';
import 'package:latlong/latlong.dart';
part 'chat_event.dart';
part 'chat_state.dart';
part 'chat_bloc_extension.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> implements TimePickerDelegate {
  
  // MARK: - Props

  final ChatsRepository chatsRepository;
  final ChatRepository chatRepository;
  final SendMessage sendMessage;
  final GetMessages getMessages;
  final GetMessagesContext getMessagesContext;
  final SetTimeDeleted setTimeDeleted;
  final int chatId;

  var _random = Random();
  AutoScrollController scrollController = AutoScrollController();

  MessageSend _messageNeededToBeSentEvent;

  // MARK: - Constructor

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
      (deleteMessageEntity) {
        add(MessageDelete(deleteMessageEntity: deleteMessageEntity));
      }
    );
  }
 
  StreamSubscription<Message> _chatSubscription;

  StreamSubscription<DeleteMessageEntity> _chatDeleteSubscription;

  // * * Main

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ChatScreenStarted) {
      yield* _chatInitialEventToState();
    } else if (event is MessageAdded) {
      yield* _messageAddedToState(event);
    } else if (event is MessageSend) {
      if (state.isSecretModeOn && state.currentTimerOption == null) {
        _messageNeededToBeSentEvent = event;
        BuildContext context = sl<Application>().navKey.currentContext;
        Navigator.push(context, TimePickerScreen.route(this));
      } else {
        yield* _messageSendToState(event);
      }
    } else if (event is MessageDelete) {
      yield* _messageDeleteToState(event);
    } else if (event is LoadMessages) {
      if (this.state.hasReachBottomMax && event.resetAll) {
        scrollController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.bounceInOut);
      } else {
        yield getNewState<ChatLoading>(
          isPagination: event.isPagination,
          messages: event.resetAll ? [] : this.state.messages,
          hasReachedMax: event.resetAll ? false : this.state.hasReachedMax,
          hasReachBottomMax: event.resetAll ? false : this.state.hasReachBottomMax,
          direction: event.resetAll ? null : event.direction,
          unreadCount: event.resetAll ? null : state.unreadCount,
        );

        Either<Failure, ChatMessageResponse> response;
        
        if (event.messageID != null) {
          var index = state.messages.indexWhere((e) => e.id == event.messageID);
          if (index == -1) {
            response = await getMessagesContext(GetMessagesContextParams(
              chatID: chatId, 
              messageID: event.messageID
            ));
          } else {
            yield getNewState<ChatInitial>(
              focusMessageID: event.messageID
            );
          }
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

        if (response != null) {
          yield* _eitherMessagesOrErrorState(
            response, 
            event.isPagination, 
            event.resetAll,
            event.direction,
            event.messageID,
            event.isInitial
          );
        }
      }
    } else if (event is SetInitialTime) {
      yield getNewState<ChatLoadingSilently>();

      final response = await setTimeDeleted(SetTimeDeletedParams(
        id: chatId, 
        isOn: event.isOn
      ));

      yield* _eitherSentWithTimerOrFailure(response, event);
    } else if (event is DisposeChat) {
      await chatRepository.disposeChat();
    } else if (event is ToggleBottomPin) {
      yield getNewState<ChatInitial>(
        unreadCount: event.newUnreadCount ?? state.unreadCount,
        showBottomPin: event.show,
      );
    } else if (event is PermissionsUpdated) {
      yield getNewState(
        oldState: state,
        chatEntity: state.chatEntity.clone(permissions: event.newPermissions)
      );
    } else if (event is UpdateTimerOption) {
      if (event.newTimerOption == null) {
        BuildContext context = sl<Application>().navKey.currentContext;
        Navigator.push(context, TimePickerScreen.route(this));
      } else {
        yield getNewState(
          oldState: state,
          currentTimerOption: event.newTimerOption
        );
      }
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
        
        return getNewState<ChatError>(
          messages: list,
          message: failure.message,
        );
      },
      (message) {
        var i = list.indexWhere((element) => element.identificator == message.identificator);
        
        list[i]= message.copyWith(
          identificator: message.id,
        );

        return getNewState<ChatInitial>(
          messages: list,
        );
      }
    );
  }
  
  Stream<ChatState> _eitherMessagesOrErrorState (
    Either<Failure, ChatMessageResponse> failureOrMessage,
    bool isPagination,
    bool isReset,
    RequestDirection direction,
    int focusMessageID,
    bool isInitial
  ) async* {
    yield failureOrMessage.fold(
      (failure) => getNewState(
        message: failure.message,
      ),
      (result) {
        List<Message> newMessages = isPagination ? direction == RequestDirection.top ? 
          ((this.state.messages ?? []) + result.result.data) : result.result.data + (state.messages ?? []) : result.result.data;
        
        bool hasReachBottom;
        if (focusMessageID != null) {
          hasReachBottom = false;
        } else if (direction == RequestDirection.bottom) {
          if (isReset) {
            hasReachBottom = true;
          } else {
            hasReachBottom = result.result.hasReachMax;
          }
        } else {
          hasReachBottom = direction != RequestDirection.bottom  ?
            state.hasReachBottomMax : result.result.hasReachMax;
        }

        Message myLastMessage;
        
        if (isInitial) {
          myLastMessage = newMessages.firstWhere((e) => 
            e.user?.id == sl<AuthConfig>().user.id, orElse: () => null
          );
        }

        return getNewState<ChatInitial>(
          topMessage: result.topMessage,
          messages: newMessages,
          unreadCount: hasReachBottom ? null : state.unreadCount,
          focusMessageID: focusMessageID,
          hasReachBottomMax: hasReachBottom,
          hasReachedMax: isPagination && direction != RequestDirection.top ? 
            state.hasReachedMax : result.result.hasReachMax,
          currentTimerOption: isInitial ? 
            TimeRangesUIExtension.getTimeOption(myLastMessage?.timeDeleted) : state.currentTimerOption
        );
      }
    );
  }

  Stream<ChatState> _messageAddedToState(MessageAdded event) async* {
    switch (event.message.messageHandleType) {
      case MessageHandleType.newMessage:
        if (state.hasReachBottomMax) {
          var list = getCopyMessages();
          var i = list.indexWhere((e) => e.identificator == event.message.id);
          
          if (i != -1) {
            list[i] = event.message;
          } else {
            list.insert(0, event.message);
          }

          bool didNotRead = 
            scrollController.offset > scrollController.position.viewportDimension * 1.5;

          yield getNewState<ChatInitial>(
            messages: list,
            unreadCount: didNotRead ? (state.unreadCount ?? 0) + 1 : state.unreadCount,
          );
        } else {
          yield getNewState<ChatInitial>(
            unreadCount: (state.unreadCount ?? 0) + 1,
          );
        }

        if (event.message.user?.id != sl<AuthConfig>().user?.id) {
          chatRepository.markMessageAsRead(MarkAsReadParams(id: chatId, messageID: event.message.id));
        }

        break;
      case MessageHandleType.userReadSecretMessage:
        if (state.hasReachBottomMax) { 
          var list = state.messages.map(
            (e) => e.copyWith(isRead: true)).toList();
          

          yield getNewState<ChatInitial>(
            messages: list,
          );
        }

        break;
      case MessageHandleType.readMessage:
        if (state.hasReachBottomMax) { 
          var list = state.messages.map(
            (e) => e.copyWith(isRead: true)).toList();
          
          yield getNewState<ChatInitial>(
            messages: list,
          );
        }

        break;
      case MessageHandleType.setTopMessage:
        yield getNewState<ChatInitial>(
          topMessage: event.message,
        );
        break;
      case MessageHandleType.unSetTopMessage:
        yield ChatInitial(
          hasReachBottomMax: state.hasReachBottomMax,
          messages: state.messages,
          hasReachedMax: state.hasReachedMax,
          wallpaperFile: state.wallpaperFile,
          unreadCount: state.unreadCount,
          showBottomPin: state.showBottomPin,
          chatEntity: state.chatEntity,
          isSecretModeOn: state.isSecretModeOn,
          topMessage: null
        );
        
        break;
    }
  }

  Stream<ChatState> _chatInitialEventToState() async* {
    File wallpaperFile = await chatsRepository.getLocalWallpaper();
    if (wallpaperFile != null) {
      yield getNewState<ChatInitial>(
        wallpaperFile: wallpaperFile,
      );
    }
  }

  Stream<ChatState> _messageSendToState(MessageSend event) async* {
    var list = getCopyMessages();
    int randomID = _random.nextInt(99999);

    StreamController<double> controller = StreamController<double>();

    List<FileMedia> localFiles;
    if (event.memoryPhotos != null) {
      localFiles = getLocalFiles(event.memoryPhotos);
    } else {
      localFiles = getLoadFiles(event);
    }

    var newMessage = Message(
      user: MessageUser(
        id: sl<AuthConfig>().user.id,
      ),
      transfer: event.forwardMessage!= null ? [event.forwardMessage] : [],
      text: event.message,
      files: localFiles,
      identificator: randomID,
      isRead: false,
      messageStatus: MessageStatus.sending,
      contacts: event.contact != null ? [
        event.contact
      ] : [],
      uploadController: controller,
      dateTime: DateTime.now(),
    );
    
    list.insert(0, newMessage);    

    yield getNewState<ChatInitial>(
      messages: list,
      currentTimerOption: event.timeOption ?? state.currentTimerOption
    );
    
    List<int> forwardArray = [];
    if (event.forwardMessage != null) {
      forwardArray.add(event.forwardMessage.id);
    }

    final response = await sendMessage(SendMessageParams(
      chatID: chatId,
      text: event.message,
      identificator: randomID,
      forwardIds: forwardArray,
      timeLeft: (event.timeOption ?? state.currentTimerOption)?.seconds,
      fieldFiles: event.fieldFiles,
      uploadController: controller,
      location: event.location,
      locationAddress: event.address,
      contactID: event.contact?.id,
      fieldAssets: event.fieldAssets,
    ));
    print("sent with timer ${(event.timeOption ?? state.currentTimerOption)?.seconds}");
    controller.close();

    yield* _eitherSentOrErrorState(response, randomID);
  }

  Stream<ChatState> _messageDeleteToState(MessageDelete event) async* {
    if(event.deleteMessageEntity.userId == sl<AuthConfig>().user.id && event.deleteMessageEntity.deleteActionType == DeleteActionType.deleteSelf){
      var list = getDeleteList(event.deleteMessageEntity);
      yield getNewState<ChatInitial>(
        messages: list,
      );
    }else if (event.deleteMessageEntity.deleteActionType == DeleteActionType.deleteAll){
      var list = getDeleteList(event.deleteMessageEntity);
      yield getNewState<ChatInitial>(
        messages: list,
      );
    }else{
      yield getNewState<ChatInitial>();
    }
  }

  List<Message> getDeleteList(DeleteMessageEntity entity){
    var list = getCopyMessages();  
    entity.messagesIds.forEach((id) { 
      list.removeWhere((message) => message.id == id);
    });
    return list;
  }
  // * * Time Deletion

  Stream<ChatState> _eitherSentWithTimerOrFailure(
    Either<Failure, ChatPermissions> failureOrNoParams,
    SetInitialTime event
  ) async* {
    yield failureOrNoParams.fold(
      (failure) => getNewState<ChatError>(
        message: failure.message,
      ),
      (response) {
        return getNewState<ChatInitial>(
          isSecretModeOn: response.isSecret,
          currentTimerOption: response.isSecret ? 
            state.currentTimerOption : null,
          isTimerDeleted: true
        );
      }
    );
  }

  getLoadFiles(MessageSend event){
    var fieldFiles = event.fieldFiles;
    if (fieldFiles != null) {
      switch (fieldFiles.fieldKey){
        case TypeMedia.audio:
          return [
            FileMedia(type: TypeMedia.audio)
          ];
        case TypeMedia.video:
          return [
            FileMedia(type: TypeMedia.video, url: fieldFiles.files[0].path)
          ];
        case TypeMedia.image:
          return [
            FileMedia(type: TypeMedia.image, memoryPhotos: event.memoryPhotos, isLocal: true)
          ];
        default:
          return null;
      }
    } else {
      return null;
    }
  }

  getLocalFiles(memoryPhotos){
    return [FileMedia(type: TypeMedia.image, memoryPhotos: memoryPhotos, isLocal: true)];
  }


  List<Message> getCopyMessages() => state.messages.map((e) => e.copyWith()).toList();

  @override
  void didSelectTimeOption(TimeOptions option) {
    if (state.isSecretModeOn && state.currentTimerOption == null) { 
      if (_messageNeededToBeSentEvent != null) {
        var newEvent = _messageNeededToBeSentEvent.copyWith(
          timeOption: option,
          selectedTimer: true
        );

        this.add(UpdateTimerOption(newTimerOption: option));
        this.add(newEvent);
      }
    } else {
      this.add(UpdateTimerOption(newTimerOption: option));
    }
  }
}
