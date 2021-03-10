import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/services/network/socket_service.dart';
import 'package:messenger_mobile/core/utils/error_handler.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';
import 'package:messenger_mobile/modules/chat/data/models/chat_detailed_model.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_model.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/core/utils/http_response_extension.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_model.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';

import '../../../../locator.dart';

abstract class ChatDataSource {
  Future<ChatDetailed> getChatDetails (int id);
  Future<PaginatedResult<ContactEntity>> getChatMembers (int id, Pagination pagination);
  Stream<Message> get messages;
  Future<Message> sendMessage(SendMessageParams params);
}

class ChatDataSourceImpl implements ChatDataSource {
  
  final http.Client client;
  final SocketService socketService;
  final int id;
  ChatDataSourceImpl({
    @required this.id,
    @required this.client,
    @required this.socketService,
  }){
      socketService.echo.channel(SocketChannels.getChatByID(id)).listen('.messages.$id', (updates) {
        _controller.add(MessageModel.fromJson(updates['message']));
      });
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

  final StreamController _controller = StreamController<Message>();

  @override
  Stream<Message> get messages async* {
    yield* _controller.stream;
  }

  @override
  Future<Message> sendMessage(SendMessageParams params) async {
    http.Response response = await client.post(
      Endpoints.sendMessages.buildURL(urlParams: [
        params.chatID.toString(),
      ],queryParameters: {
        'text': params.text ?? ''
      }),
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
}