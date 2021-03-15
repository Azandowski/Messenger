import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

abstract class ChatDataSource {
  Future<ChatDetailed> getChatDetails (int id);
  Future<PaginatedResult<ContactEntity>> getChatMembers (int id, Pagination pagination);
  Future<ChatDetailed> addMembers (int id, List<int> userIDs);
  Future<ChatDetailed> kickMember (int id, int userID);
  Stream<Message> get messages;
  Future<Message> sendMessage(SendMessageParams params);
  Future<bool> deleteMessage(DeleteMessageParams params);
  Future<void> leaveChat (int id);
  Future<ChatPermissions> updateChatSettings ({
    Map chatUpdates,
    int id
  });
  Future<PaginatedResultViaLastItem<Message>> getChatMessages (int lastMessageId);
  
  // TODO: Finish later
  Future<void> setTimeDeleted ({
    int id, int timeInSeconds
  });

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
    socketService.echo.channel(SocketChannels.getChatByID(44))
      .listen(
        '.messages.$id', 
        (updates) {
          _controller.add(MessageModel.fromJson(updates['message']));
        }
      );
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
  final StreamController _controller = StreamController<Message>();

  @override
  Stream<Message> get messages async* {
    yield* _controller.stream;
  }
  
  @override
  Future<Message> sendMessage(SendMessageParams params) async {
    var forward = params.forwardIds.map((e) => e.toString()).join(',');
    var body =  {
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
  Future<PaginatedResultViaLastItem<Message>> getChatMessages (int lastMessageId) async {
    http.Response response = await client.get(
      Endpoints.getChatMessages.buildURL(
        urlParams: [
          '$id'
        ],
        queryParameters: {
          if (lastMessageId != null)
            'last_message_id': '$lastMessageId'
        }
      ),
      headers: Endpoints.changeChatSettings.getHeaders(token: sl<AuthConfig>().token),
    );

    if (response.isSuccess) {
      var responseJSON = json.decode(response.body);
      List data = ((responseJSON['messages'] ?? [])).map((e) => MessageModel.fromJson(e)).toList();
      return PaginatedResultViaLastItem<Message>(
        data: data.cast<Message>(),
        hasReachMax: !responseJSON['hasMoreResults']
      );
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<void> disposeChat() {
    socketService.echo.leave(SocketChannels.getChatByID(id));
  }


  // TODO: Works Partly, No need to touch

  @override 
  Future<void> setTimeDeleted ({
    @required int timeInSeconds,
    @required int id
  }) async {
    http.Response response = await client.post(
      Endpoints.setTimeDeleted.buildURL(),
      headers: Endpoints.changeChatSettings.getHeaders(token: sl<AuthConfig>().token),
      body: json.encode({
        'time_deleted': '$timeInSeconds',
        'chat_id': '$id'
      })
    );

    if (!response.isSuccess) { 
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<bool> deleteMessage(DeleteMessageParams params) async {
     http.Response response = await client.post(
      Endpoints.deleteMessage.buildURL(),
      body: json.encode(params.body),
      headers: Endpoints.changeChatSettings.getHeaders(token: sl<AuthConfig>().token),
    );
    print(response.statusCode);
    print(response.body);
    if (response.isSuccess) {
      return true;
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }
}