import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/core/utils/error_handler.dart';
import 'package:messenger_mobile/modules/chat/data/models/chat_detailed_model.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/core/utils/http_response_extension.dart';

import '../../../../locator.dart';

abstract class ChatDataSource {
  Future<ChatDetailed> getChatDetails (int id);
}


class ChatDataSourceImpl implements ChatDataSource {
  
  final http.Client client;

  ChatDataSourceImpl({
    @required this.client
  });

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
}