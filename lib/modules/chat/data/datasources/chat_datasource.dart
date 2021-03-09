import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/utils/error_handler.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';
import 'package:messenger_mobile/modules/chat/data/models/chat_detailed_model.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/core/utils/http_response_extension.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_model.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_response.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';

import '../../../../locator.dart';

abstract class ChatDataSource {
  Future<ChatDetailed> getChatDetails (int id);
  Future<PaginatedResult<ContactEntity>> getChatMembers (int id, Pagination pagination);
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
}