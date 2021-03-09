import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/core/services/network/socket_service.dart';
import 'package:messenger_mobile/core/utils/error_handler.dart';
import 'package:messenger_mobile/modules/chat/data/models/chat_detailed_model.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_model.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/core/utils/http_response_extension.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';

import '../../../../locator.dart';

abstract class ChatDataSource {
  Future<ChatDetailed> getChatDetails (int id);

  Stream<Message> get messages;
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
      socketService.echo.channel(SocketChannels.getChatByID(id)).listen('.messages.$id', (updates) => _controller.add(MessageModel.fromJson(updates['message'])));
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

  final _controller = StreamController<Message>();

  @override
  Stream<Message> get messages async* {
    yield* _controller.stream;
  }
}