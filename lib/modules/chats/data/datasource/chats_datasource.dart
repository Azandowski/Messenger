import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/config/auth_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../../core/services/network/socket_service.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/http_response_extension.dart';
import '../../../../locator.dart';
import '../../../category/data/models/chat_entity_model.dart';
import '../../../category/domain/entities/chat_entity.dart';
import '../../domain/entities/chat_search_response.dart';
import '../model/chat_search_response_model.dart';
import '../model/chat_update_type.dart';

abstract class ChatsDataSource {
  Future<PaginatedResultViaLastItem<ChatEntity>> getUserChats(
      {@required String token, int lastChatId});

  Future<PaginatedResultViaLastItem<ChatEntity>> getCategoryChat(
      {@required String token, @required int categoryID, int lastChatId});

  Stream<ChatEntity> get chats;

  Future<File> getLocalWallpaper();

  Future<void> setLocalWallpaper(File file);

  Future<ChatMessageResponse> searchChats(
      {Uri nextPageURL, String queryText, int chatID});
}

class ChatsDataSourceImpl implements ChatsDataSource {
  final http.Client client;
  final SocketService socketService;
  final AuthConfig authConfig;

  ChatsDataSourceImpl({
    @required this.client,
    @required this.socketService,
    @required this.authConfig,
  });

  void init() {
    int userID = authConfig.user.id;

    socketService.echo
        .channel(SocketChannels.getChatsUpdates(userID))
        .listen('.get.index.$userID', (updates) {
      Map chatJSON = updates['chat'];
      chatJSON['last_message'] = updates['last_message'];
      chatJSON['category_chat'] = updates['category_chat'];
      chatJSON['settings'] = updates['settings'];
      chatJSON['no_read_message'] = updates['no_read_message'];

      ChatEntityModel model = ChatEntityModel.fromJson(chatJSON);
      model.chatUpdateType = (updates['type'] as String).getChatUpdateType;
      _controller.add(model);
    });
  }

  /**
  * * Loading List of user's all chats via token
  */
  @override
  Future<PaginatedResultViaLastItem<ChatEntity>> getUserChats(
      {@required String token, int lastChatId}) async {
    http.Response response = await client.get(
      Endpoints.getAllUserChats.buildURL(queryParameters: {
        if (lastChatId != null) 'last_chat_id': '$lastChatId'
      }),
      headers: Endpoints.getAllUserChats.getHeaders(token: token),
    );

    if (response.isSuccess) {
      var responseJSON = json.decode(response.body);

      return PaginatedResultViaLastItem<ChatEntity>(
          data: ((responseJSON['chats'] ?? []) as List)
              .map((e) => ChatEntityModel.fromJson(e))
              .toList(),
          hasReachMax: !responseJSON['has_more_results']);
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<ChatMessageResponse> searchChats(
      {Uri nextPageURL, String queryText, int chatID}) async {
    String nextPageLink;
    if (nextPageURL != null) {
      nextPageLink = nextPageURL.toString() +
          "&search=${queryText}" +
          (chatID != null ? '&chat_id=${chatID}' : '');
    }

    http.Response response = await client.get(
        nextPageURL != null
            ? nextPageLink
            : Endpoints.searchChats.buildURL(queryParameters: {
                'search': queryText,
                if (chatID != null) ...{'chat_id': '$chatID'}
              }),
        headers:
            Endpoints.searchChats.getHeaders(token: sl<AuthConfig>().token));

    if (response.isSuccess) {
      var responseJSON = json.decode(response.body);
      return ChatSearchResponseModel.fromJson(responseJSON);
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<PaginatedResultViaLastItem<ChatEntity>> getCategoryChat(
      {@required String token,
      @required int categoryID,
      int lastChatId}) async {
    http.Response response = await client.get(
      Endpoints.categoryChats.buildURL(urlParams: [
        '$categoryID'
      ], queryParameters: {
        if (lastChatId != null) 'last_chat_id': '$lastChatId'
      }),
      headers: Endpoints.categoryChats.getHeaders(token: token),
    );

    if (response.isSuccess) {
      var responseJSON = json.decode(response.body);

      return PaginatedResultViaLastItem<ChatEntity>(
          data: ((responseJSON['chats'] ?? []) as List)
              .map((e) => ChatEntityModel.fromJson(e))
              .toList(),
          hasReachMax: !responseJSON['hasMoreResults']);
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<File> getLocalWallpaper() async {
    Directory appDocumentsDirectory = await getTemporaryDirectory();
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
    Directory appDocumentsDirectory = await getTemporaryDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/wallpaper.png';
    File oldImage = File(filePath);
    if (await oldImage.exists()) {
      await oldImage.delete();
    }
    await file.copy(filePath);
    imageCache.clear();
  }

  @override
  Stream<ChatEntity> get chats async* {
    yield* _controller.stream;
  }

  @override
  final StreamController _controller = StreamController<ChatEntity>.broadcast();
}
