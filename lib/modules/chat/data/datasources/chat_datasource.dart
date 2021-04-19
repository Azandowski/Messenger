import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/modules/chat/data/models/delete_messages_model.dart';
import 'package:messenger_mobile/modules/chat/data/models/translation_response.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/delete_messages.dart';
import '../../../../core/config/auth_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../../core/services/network/socket_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/http_response_extension.dart';
import '../../../../core/utils/multipart_request_helper.dart';
import '../../../../core/utils/pagination.dart';
import '../../../../locator.dart';
import '../../../category/data/models/chat_permission_model.dart';
import '../../../category/domain/entities/chat_permissions.dart';
import '../../../creation_module/data/models/contact_model.dart';
import '../../../creation_module/domain/entities/contact.dart';
import '../../domain/entities/chat_detailed.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/params.dart';
import '../../presentation/chat_details/page/chat_detail_screen.dart';
import '../../presentation/chats_screen/pages/chat_screen_import.dart';
import '../models/chat_detailed_model.dart';
import '../models/chat_message_response.dart';
import '../models/message_model.dart';

enum RequestDirection { top, bottom }

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
  Future<ChatDetailed> getChatDetails(int id, ProfileMode mode);
  Future<PaginatedResult<ContactEntity>> getChatMembers(
      int id, Pagination pagination);
  Future<ChatDetailed> addMembers(int id, List<int> userIDs);
  Future<ChatDetailed> kickMember(int id, int userID);
  Stream<Message> get messages;
  Stream<DeleteMessageEntity> get deleteIds;
  Future<Message> sendMessage(SendMessageParams params);
  Future<bool> deleteMessage(DeleteMessageParams params);
  Future<bool> attachMessage(Message message);
  Future<bool> disAttachMessage(NoParams noParams);
  Future<bool> replyMore(ReplyMoreParams params);
  Future<void> leaveChat(int id);
  Future<ChatPermissions> updateChatSettings({Map chatUpdates, int id});
  Future<ChatMessageResponse> getChatMessages(
      int lastMessageId, RequestDirection direction);
  Future<ChatMessageResponse> getChatMessageContext(int chatID, int messageID);
  Future<bool> blockUser(int id);
  Future<bool> unblockUser(int id);
  Future<void> disposeChat();
  Future<void> markAsRead(int id, int messageID);
  Future<TranslationResponse> translateText(
      {@required String originalText, @required String langCode});
}

class ChatDataSourceImpl implements ChatDataSource {
  final http.Client client;
  final http.MultipartRequest multipartRequest;
  final SocketService socketService;
  final int id;
  final AuthConfig authConfig;

  ChatDataSourceImpl({
    @required this.id,
    @required this.client,
    @required this.socketService,
    @required this.multipartRequest,
    @required this.authConfig,
  }) {
    socketService.echo
        .channel(SocketChannels.getChatByID(id))
        .listen('.messages.$id', (updates) {
      MessageModel messageModel = MessageModel.fromJson(updates['message']);
      messageModel.messageHandleType = handleTypeMessage(updates['type']);
      var transfers;

      if (updates['transfer'] != null) {
        transfers = ((updates['transfer'] ?? []) as List)
            .map((e) => Transfer.fromJson(e))
            .toList();
      }

      messageModel.transfer = transfers;
      _controller.add(messageModel);
    });
    socketService.echo
        .channel(SocketChannels.getChatDeleteById(id))
        .listen('.deleted.message.$id', (deletions) {
      print(deletions);
      DeleteMessageModel model = DeleteMessageModel.fromJson(deletions);
      _deleteController.add(model);
    });
  }

  MessageHandleType handleTypeMessage(String type) {
    switch (type) {
      case 'NewMessage':
        return MessageHandleType.newMessage;
      case 'SetTopMessage':
        return MessageHandleType.setTopMessage;
      case 'unSetTopMessage':
        return MessageHandleType.unSetTopMessage;
      case 'StartTimerSecretMessage':
        return MessageHandleType.userReadSecretMessage;
      case 'MessageRead':
        return MessageHandleType.readMessage;
    }
  }

  @override
  Future<ChatDetailed> getChatDetails(int id, ProfileMode mode) async {
    http.Response response = await client.get(
        mode == ProfileMode.chat
            ? Endpoints.getChatDetails.buildURL(urlParams: ['$id'])
            : Endpoints.getUserProfile
                .buildURL(queryParameters: {'user_id': '$id'}),
        headers: Endpoints.getChatDetails.getHeaders(token: authConfig.token));

    if (response.isSuccess) {
      return ChatDetailedModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<PaginatedResult<ContactEntity>> getChatMembers(
      int id, Pagination pagination) async {
    http.Response response = await client.get(
      Endpoints.chatMembers.buildURL(queryParameters: {
        'limit': pagination.limit.toString(),
        'page': pagination.page.toString(),
      }, urlParams: [
        '$id'
      ]),
      headers: Endpoints.getCurrentUser.getHeaders(token: authConfig.token),
    );

    if (response.isSuccess) {
      var jsonMap = json.decode(response.body);

      return PaginatedResult<ContactEntity>.fromJson(
          jsonMap, (data) => ContactModel.fromJson(data));
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  final StreamController<Message> _controller = StreamController<Message>();

  @override
  final StreamController<DeleteMessageEntity> _deleteController =
      StreamController<DeleteMessageEntity>();

  @override
  Stream<Message> get messages async* {
    yield* _controller.stream;
  }

  @override
  Stream<DeleteMessageEntity> get deleteIds async* {
    yield* _deleteController.stream;
  }

  @override
  Future<Message> sendMessage(SendMessageParams params) async {
    String type;
    List<String> keyNames = [];
    _handleFilesForSendMessages(
        params: params,
        callback: (String newType, List<String> keyName) {
          type = newType;
          keyNames = keyName;
        });

    var data = _generateBodyForSendMessage(params: params, type: type);

    http.StreamedResponse streamedResponse =
        await MultipartRequestHelper.postData(
            token: sl<AuthConfig>().token,
            uploadStreamCtrl: params?.uploadController,
            request: multipartRequest,
            data: data,
            assets: params.fieldAssets?.assets != null
                ? params.fieldAssets.assets
                : [],
            files: params.fieldFiles?.files != null
                ? params.fieldFiles?.files
                : null,
            keyName: keyNames);

    final response = await http.Response.fromStream(streamedResponse);

    if (response.isSuccess) {
      Message message = MessageModel.fromJson(json.decode(response.body));
      message.identificator = params.identificator;
      return message;
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<ChatDetailed> addMembers(int id, List<int> userIDs) async {
    http.Response response = await client.post(
        Endpoints.addMembersToChat.buildURL(urlParams: ['$id']),
        headers: Endpoints.addMembersToChat.getHeaders(token: authConfig.token),
        body: json.encode({'contact': userIDs.join(',')}));

    if (response.isSuccess) {
      return ChatDetailedModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<ChatDetailed> kickMember(int id, int userID) async {
    http.Response response = await client.post(
        Endpoints.kickUser.buildURL(urlParams: ['$id']),
        headers: Endpoints.kickUser.getHeaders(token: authConfig.token),
        body: json.encode({'contact': userID}));

    if (response.isSuccess) {
      return ChatDetailedModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<void> leaveChat(int id) async {
    http.Response response = await client.post(
      Endpoints.leaveChat.buildURL(urlParams: ['$id']),
      headers: Endpoints.addMembersToChat.getHeaders(token: authConfig.token),
    );

    if (!response.isSuccess) {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<ChatPermissions> updateChatSettings(
      {@required Map chatUpdates, @required int id}) async {
    http.Response response = await client.post(
        Endpoints.changeChatSettings.buildURL(urlParams: ['$id']),
        headers:
            Endpoints.changeChatSettings.getHeaders(token: authConfig.token),
        body: json.encode(chatUpdates));

    if (response.isSuccess) {
      return ChatPermissionModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<ChatMessageResponse> getChatMessages(
      int lastMessageId, RequestDirection direction) async {
    print("request lastMessageId: $lastMessageId, type: $direction");
    http.Response response = await client.get(
      Endpoints.getChatMessages.buildURL(
        urlParams: ['$id'],
        queryParameters: {
          if (direction != null && lastMessageId != null) ...{
            'type': direction.key
          },
          if (lastMessageId != null) ...{'last_message_id': '$lastMessageId'}
        },
      ),
      headers: Endpoints.changeChatSettings.getHeaders(token: authConfig.token),
    );

    if (response.isSuccess) {
      var responseJSON = json.decode(response.body);
      List data = ((responseJSON['messages'] ?? []))
          .map((e) => MessageModel.fromJson(e))
          .toList();
      return ChatMessageResponse(
          result: PaginatedResultViaLastItem<Message>(
              data: data.cast<Message>(),
              hasReachMax: !responseJSON['hasMoreResults']),
          topMessage: responseJSON['top_message'] != null
              ? MessageModel.fromJson(responseJSON['top_message'])
              : null);
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<ChatMessageResponse> getChatMessageContext(
      int chatID, int messageID) async {
    http.Response response = await client.get(
        Endpoints.getMessagesContext
            .buildURL(urlParams: ['$chatID', '$messageID']),
        headers:
            Endpoints.getMessagesContext.getHeaders(token: authConfig.token));

    if (response.isSuccess) {
      var responseJSON = json.decode(response.body);
      List data = ((responseJSON['messages'] ?? []))
          .map((e) => MessageModel.fromJson(e))
          .toList();
      return ChatMessageResponse(
          result: PaginatedResultViaLastItem<Message>(
              data: data.cast<Message>(),
              hasReachMax: !responseJSON['has_more_results_top'],
              hasReachMaxSecondSide: !responseJSON['has_more_results_bot']),
          topMessage: responseJSON['top_message'] != null
              ? MessageModel.fromJson(responseJSON['top_message'])
              : null);
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
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
      headers: Endpoints.changeChatSettings.getHeaders(token: authConfig.token),
    );
    if (response.isSuccess) {
      return true;
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<bool> attachMessage(Message message) async {
    http.Response response = await client.post(
      Endpoints.attachMessage.buildURL(urlParams: ['$id']),
      body: json.encode({'message_id': message.id.toString()}),
      headers: Endpoints.changeChatSettings.getHeaders(token: authConfig.token),
    );
    print(response.body);
    print(response.statusCode);
    if (response.isSuccess) {
      return true;
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<bool> disAttachMessage(NoParams noParams) async {
    http.Response response = await client.post(
      Endpoints.disAttachMessage.buildURL(urlParams: ['$id']),
      headers: Endpoints.changeChatSettings.getHeaders(token: authConfig.token),
    );
    if (response.isSuccess) {
      return true;
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<bool> replyMore(ReplyMoreParams params) async {
    http.Response response = await client.post(
      Endpoints.replyMore.buildURL(),
      body: json.encode({
        'chats': params.chatIds.map((e) => e.toString()).join(','),
        'forward': params.messageIds.map((e) => e.toString()).join(',')
      }),
      headers: Endpoints.changeChatSettings.getHeaders(token: authConfig.token),
    );

    if (response.isSuccess) {
      return true;
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<bool> blockUser(int id) async {
    http.Response response = await client.post(
      Endpoints.blockUser.buildURL(),
      body: json.encode({'contact': id}),
      headers: Endpoints.blockUser.getHeaders(token: authConfig.token),
    );

    if (response.isSuccess) {
      return true;
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<bool> unblockUser(int id) async {
    http.Response response = await client.post(
      Endpoints.unblockUser.buildURL(),
      body: json.encode({'contact': id}),
      headers: Endpoints.unblockUser.getHeaders(token: authConfig.token),
    );

    if (response.isSuccess) {
      return true;
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<void> markAsRead(int id, int messageID) async {
    print(Endpoints.markAsRead.buildURL());
    http.Response response = await client.post(
      Endpoints.markAsRead.buildURL(),
      body: json.encode({'message_id': '$messageID'}),
      headers: Endpoints.markAsRead.getHeaders(token: sl<AuthConfig>().token),
    );

    if (!response.isSuccess) {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  // MARK: - Utils

  void _handleFilesForSendMessages(
      {SendMessageParams params, Function(String, List<String>) callback}) {
    if (params.fieldFiles?.files != null) {
      callback(
          params.fieldFiles?.fieldKey?.filedKey,
          List.generate(
              params.fieldFiles?.files?.length, (index) => 'file[$index]'));
    } else if (params.fieldAssets?.assets != null) {
      callback(
          params.fieldAssets?.fieldKey?.filedKey,
          List.generate(
              params.fieldAssets.assets.length, (index) => 'file[$index]'));
    }
  }

  Map<String, dynamic> _generateBodyForSendMessage(
      {@required SendMessageParams params, @required String type}) {
    var forward = params.forwardIds.map((e) => e.toString()).join(',');

    return {
      'text': params.text ?? '',
      'forward': forward,
      'type': type,
      if (params.timeLeft != null) ...{'time_deleted': params.timeLeft},
      if (params.location != null) ...{
        'latitude': params.location.latitude,
        'longitude': params.location.longitude,
        'address': params.locationAddress
      },
      if (params.contactID != null) ...{'contact_id': '${params.contactID}'}
    };
  }

  Future<TranslationResponse> translateText(
      {@required String originalText, @required String langCode}) async {
    // return Future.delayed(Duration(seconds: 1), () {
    //   return TranslationResponse(
    //     detectedLanguage: 'en',
    //     text: 'Привет',
    //     detectedLanguageUnformatted: 'en'
    //   );
    // });

    http.Response response = await client.post(
        Uri.parse(
            "https://translate.api.cloud.yandex.net/translate/v2/translate"),
        body: json.encode({
          "folder_id": "b1gkq1ghkfika97l9en2",
          'texts': [originalText],
          'targetLanguageCode': langCode
        }),
        headers: {
          'Authorization': 'Api-Key AQVN1vzRDlStWsG4chCPOYI3cZAwXBIIJBS2warl',
          'Content-type': 'application/json'
        });

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List translations = json.decode(
              Utf8Decoder().convert(response.bodyBytes))['translations'] ??
          [];

      if (translations.length != 0) {
        var jsonModel = translations[0];
        jsonModel['translated_to'] = langCode;
        return TranslationResponse.fromJson(jsonModel);
      } else {
        throw ServerFailure(message: 'Not Found');
      }
    } else {
      throw ServerFailure(message: response.body);
    }
  }
}
