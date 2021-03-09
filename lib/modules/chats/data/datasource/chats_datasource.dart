import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../../core/utils/http_response_extension.dart';
import '../../../category/data/models/chat_entity_model.dart';
import '../../../category/domain/entities/chat_entity.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/utils/error_handler.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_entity_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/core/utils/http_response_extension.dart';
import 'package:path_provider/path_provider.dart';

abstract class ChatsDataSource {
  Future<PaginatedResultViaLastItem<ChatEntity>> getUserChats ({
    @required String token,
    int lastChatId
  });

  Future<List<ChatEntity>> getCategoryChat ({
    @required String token,
    @required int categoryID
  });

  Future<File> getLocalWallpaper ();

  Future<void> setLocalWallpaper(File file); 
}

class ChatsDataSourceImpl extends ChatsDataSource {
  final http.Client client;

  ChatsDataSourceImpl({
    @required this.client
  });

  /**
  * * Loading List of user's all chats via token
  */
  @override
  Future<PaginatedResultViaLastItem<ChatEntity>> getUserChats({
    @required String token,
    int lastChatId
  }) async {
    http.Response response = await client.get(
      Endpoints.getAllUserChats.buildURL(queryParameters: {
        if (lastChatId != null)
          'last_message_id': '$lastChatId'
      }),
      headers: Endpoints.getAllUserChats.getHeaders(token: token),
    );
    
    if (response.isSuccess) {
      var responseJSON = json.decode(response.body);

      return PaginatedResultViaLastItem<ChatEntity>(
        data: ((responseJSON['chats'] ?? []) as List).map(
          (e) => ChatEntityModel.fromJson(e)).toList(),
        hasReachMax: responseJSON['has_more_results']
      );
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<List<ChatEntity>> getCategoryChat({
    @required String token, 
    @required int categoryID
  }) async {
      http.Response response = await client.get(
        Endpoints.categoryChats.buildURL(urlParams: ['$categoryID']),
        headers: Endpoints.getAllUserChats.getHeaders(token: token),
      );

    if (response.isSuccess) { 
      List chats = (json.decode(response.body)['chats'] as List);
      return chats.map((e) => ChatEntityModel.fromJson(e)).toList();
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<File> getLocalWallpaper() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); 
    String appDocumentsPath = appDocumentsDirectory.path; 
    String filePath = '$appDocumentsPath/wallpaper.png';
    File output;
    
    try {
      output = File(filePath);
    } catch (e) {}

    return output;
  }

  @override
  Future<void> setLocalWallpaper(File file) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); 
    String appDocumentsPath = appDocumentsDirectory.path; 
    String filePath = '$appDocumentsPath/wallpaper.png';
    file.copy(filePath);
  } 
}
