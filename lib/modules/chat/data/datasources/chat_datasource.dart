import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chat/data/models/chat_message_response.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';

import '../../../../core/config/auth_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../../core/services/network/socket_service.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/http_response_extension.dart';
import '../../../../core/utils/pagination.dart';
import '../../../../locator.dart';
import '../../../category/data/models/chat_permission_model.dart';
import '../../../category/domain/entities/chat_permissions.dart';
import '../../../creation_module/data/models/contact_model.dart';
import '../../../creation_module/domain/entities/contact.dart';
import '../../domain/entities/chat_detailed.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/params.dart';
import '../models/chat_detailed_model.dart';
import '../models/message_model.dart';


enum RequestDirection {
  top, bottom
}

extension RequestExension on RequestDirection {
  String get key {
    switch (this) {
      case RequestDirection.top:
        return 'top';
      case RequestDirection.bottom:
        return 'bot';
    }
  }
}


abstract class ChatDataSource {
  Future<ChatDetailed> getChatDetails (int id);
  Future<PaginatedResult<ContactEntity>> getChatMembers (int id, Pagination pagination);
  Future<ChatDetailed> addMembers (int id, List<int> userIDs);
  Future<ChatDetailed> kickMember (int id, int userID);
  Stream<Message> get messages;
  Stream<List<int>> get deleteIds;
  Future<Message> sendMessage(SendMessageParams params);
  Future<bool> deleteMessage(DeleteMessageParams params);
  Future<bool> attachMessage(Message message);
  Future<bool> disAttachMessage(NoParams noParams);
  Future<bool> replyMore(ReplyMoreParams params);
  Future<void> leaveChat (int id);
  Future<ChatPermissions> updateChatSettings ({
    Map chatUpdates,
    int id
  });
  Future<ChatMessageResponse> getChatMessages (
    int lastMessageId, RequestDirection direction
  );
  Future<ChatMessageResponse> getChatMessageContext (int chatID, int messageID);

  Future<void> disposeChat();
}


class ChatDataSourceImpl implements ChatDataSource {
  
  final http.Client client;
  final SocketService socketService;
  final int id;
  
  ChatDataSourceImpl({
    @required this.id,
    @required this.client,
    @required this.socketService,
  }) {
    socketService.echo.channel(SocketChannels.getChatByID(id))
      .listen(
        '.messages.$id', 
        (updates) {
          MessageModel messageModel = MessageModel.fromJson(updates['message']);
          messageModel.messageHandleType = handleTypeMessage(updates['type']);
          var transfers;
          if(updates['transfer'] != null){
            transfers = ((updates['transfer'] ?? []) as List).map((e) => Transfer.fromJson(e)).toList();
          }
          messageModel.transfer = transfers;
          _controller.add(messageModel);
        }
      );
    socketService.echo.channel(SocketChannels.getChatDeleteById(id))
      .listen(
        '.deleted.message.$id', 
        (deletions) {
          List<int> data = ((deletions['messages_id'] ?? []) as List).cast<int>();
          _deleteController.add(data);
        }
      );
    }
  
  MessageHandleType handleTypeMessage(String type){
    switch(type){
      case 'NewMessage':
        return MessageHandleType.newMessage;
      case 'SetTopMessage':
        return MessageHandleType.setTopMessage;
      case 'unSetTopMessage':
        return MessageHandleType.unSetTopMessage;
    }
  }
   
  @override
  Future<ChatDetailed> getChatDetails(int id) async {
    http.Response response = await client.get(
      Endpoints.getChatDetails.buildURL(urlParams: ['$id']),
      headers: Endpoints.getChatDetails.getHeaders(token: sl<AuthConfig>().token)
    );

    if (response.isSuccess) {
      return ChatDetailedModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<PaginatedResult<ContactEntity>> getChatMembers(
    int id, Pagination pagination
  ) async {
    http.Response response = await client.get(
      Endpoints.chatMembers.buildURL(queryParameters: {
        'limit': pagination.limit.toString(),
        'page': pagination.page.toString(),
      }, urlParams: [
        '$id'
      ]),
      headers: Endpoints.getCurrentUser.getHeaders(token: sl<AuthConfig>().token),
    );

    if (response.isSuccess) {
      var jsonMap = json.decode(response.body);
      
      return PaginatedResult<ContactEntity>.fromJson(
        jsonMap, 
        (data) => ContactModel.fromJson(data)
      );
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override 
  final StreamController<Message> _controller = StreamController<Message>();

  @override 
  final StreamController<List<int>> _deleteController = StreamController<List<int>>();

  @override
  Stream<Message> get messages async* {
    yield* _controller.stream;
  }
   @override
  Stream<List<int>> get deleteIds async* {
    yield* _deleteController.stream;
  }

  @override
  Future<Message> sendMessage(SendMessageParams params) async {
    var forward = params.forwardIds.map((e) => e.toString()).join(',');
    var body = {
      'text': params.text ?? '',
      'forward': forward,
      if (params.timeLeft != null)
        ...{'time_deleted': params.timeLeft}
    };

    http.Response response = await client.post(
      Endpoints.sendMessages.buildURL(urlParams: [
          params.chatID.toString(),
        ],
      ),
      body: json.encode(body),
      headers: Endpoints.getCurrentUser.getHeaders(token: sl<AuthConfig>().token),
    );

    if (response.isSuccess) {
      Message message = MessageModel.fromJson(json.decode(response.body));
      message.identificator = params.identificator;
      return message;
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<ChatDetailed> addMembers(int id, List<int> userIDs) async {
    http.Response response = await client.post(
      Endpoints.addMembersToChat.buildURL(urlParams: [
        '$id'
      ]),
      headers: Endpoints.addMembersToChat.getHeaders(token: sl<AuthConfig>().token),
      body: json.encode({
        'contact': userIDs.join(',')
      })
    );

    if (response.isSuccess) {
      return ChatDetailedModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<ChatDetailed> kickMember(int id, int userID) async {
    http.Response response = await client.post(
      Endpoints.kickUser.buildURL(urlParams: [
        '$id'
      ]),
      headers: Endpoints.kickUser.getHeaders(token: sl<AuthConfig>().token),
      body: json.encode({
        'contact': userID
      })
    );

    if (response.isSuccess) {
      return ChatDetailedModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<void> leaveChat(int id) async {
    http.Response response = await client.post(
      Endpoints.leaveChat.buildURL(urlParams: [
        '$id'
      ]),
      headers: Endpoints.addMembersToChat.getHeaders(token: sl<AuthConfig>().token),
    );

    if (!response.isSuccess) {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    } 
  }

  @override
  Future<ChatPermissions> updateChatSettings({
    @required Map chatUpdates, 
    @required int id
  }) async {
    http.Response response = await client.post(
      Endpoints.changeChatSettings.buildURL(urlParams: [
        '$id'
      ]),
      headers: Endpoints.changeChatSettings.getHeaders(token: sl<AuthConfig>().token),
      body: json.encode(chatUpdates)
    );

    if (response.isSuccess) {
      return ChatPermissionModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override 
  Future<ChatMessageResponse> getChatMessages (
    int lastMessageId,
    RequestDirection direction
  ) async {
    print("request lastMessageId: $lastMessageId, type: $direction");
    http.Response response = await client.get(
      Endpoints.getChatMessages.buildURL(
        urlParams: [
          '$id'
        ],
        queryParameters: {
          if (direction != null)
          ...{'type': direction.key},
          if (lastMessageId != null)
            ...{'last_message_id': '$lastMessageId'}
        }
      ),
      headers: Endpoints.changeChatSettings.getHeaders(token: sl<AuthConfig>().token),
    );

    if (response.isSuccess) {
      var responseJSON = json.decode(response.body);
      List data = ((responseJSON['messages'] ?? [])).map((e) => MessageModel.fromJson(e)).toList();
      return ChatMessageResponse(
        result: PaginatedResultViaLastItem<Message>(
          data: data.cast<Message>(),
          hasReachMax: !responseJSON['hasMoreResults']
        ),
        topMessage: responseJSON['top_message'] != null ?
          MessageModel.fromJson(responseJSON['top_message']) : null
      );
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<ChatMessageResponse> getChatMessageContext(int chatID, int messageID) async {
    http.Response response = await client.get(
      Endpoints.getMessagesContext.buildURL(
        urlParams: [
          '$chatID',
          '$messageID'
        ]
      ),
      headers: Endpoints.getMessagesContext.getHeaders(token: sl<AuthConfig>().token)
    );

    if (response.isSuccess) {
      var responseJSON = json.decode(response.body);
      List data = ((responseJSON['messages'] ?? [])).map((e) => MessageModel.fromJson(e)).toList();
      return ChatMessageResponse(
        result: PaginatedResultViaLastItem<Message>(
          data: data.cast<Message>(),
          hasReachMax: !responseJSON['has_more_results_top'],
          hasReachMaxSecondSide: !responseJSON['has_more_results_bot']
        ),
        topMessage: responseJSON['top_message'] != null ? 
          MessageModel.fromJson(responseJSON['top_message']) : null
      );
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<void> disposeChat() {
    socketService.echo.leave(SocketChannels.getChatByID(id));
    socketService.echo.leave(SocketChannels.getChatDeleteById(id));
  }

  @override
  Future<bool> deleteMessage(DeleteMessageParams params) async {
     http.Response response = await client.post(
      Endpoints.deleteMessage.buildURL(),
      body: json.encode(params.body),
      headers: Endpoints.changeChatSettings.getHeaders(token: sl<AuthConfig>().token),
    );
    if (response.isSuccess) {
      return true;
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<bool> attachMessage(Message message) async {
    http.Response response = await client.post(
      Endpoints.attachMessage.buildURL(
        urlParams: [
          '$id'
        ]
      ),
      body: json.encode({
        'message_id': message.id.toString()
      }),
      headers: Endpoints.changeChatSettings.getHeaders(token: sl<AuthConfig>().token),
    );
    print(response.body);
    print(response.statusCode);
    if (response.isSuccess) {
      return true;
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<bool> disAttachMessage(NoParams noParams) async {
    http.Response response = await client.post(
      Endpoints.disAttachMessage.buildURL(
        urlParams: [
          '$id'
        ]
      ),
      headers: Endpoints.changeChatSettings.getHeaders(token: sl<AuthConfig>().token),
    );
    if (response.isSuccess) {
      return true;
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<bool> replyMore(ReplyMoreParams params) async {
    http.Response response = await client.post(
      Endpoints.replyMore.buildURL(),
      body: json.encode({
        'chats':   params.chatIds.map((e) => e.toString()).join(','),
        'forward': params.messageIds.map((e) => e.toString()).join(',')
      }),
      headers: Endpoints.changeChatSettings.getHeaders(token: sl<AuthConfig>().token),
    );
    if (response.isSuccess) {
      return true;
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }
}