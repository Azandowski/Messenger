
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/modules/category/data/models/chat_entity_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../../../core/utils/http_response_extension.dart';
import '../../../../core/utils/multipart_request_helper.dart';
import '../../domain/usecases/params.dart';


abstract class ChatGroupRemoteDataSource {
  Future<ChatEntity> createChatGroup({
    CreateChatGroupParams groupParams
  });
}


// * * Implementation of the CategoryDataSource
class ChatGroupRemoteDataSourceImpl implements ChatGroupRemoteDataSource {
  
  http.MultipartRequest multipartRequest;
  final http.Client client;

  ChatGroupRemoteDataSourceImpl({
    @required this.multipartRequest,
    @required this.client
  });

  @override
  Future<ChatEntity> createChatGroup({CreateChatGroupParams groupParams}) async {
    var url = groupParams.isCreate ? Endpoints.createGroupChat.buildURL() : Endpoints.updateCategory.buildURL(urlParams: ['1']);
    multipartRequest = http.MultipartRequest('POST', url);

    http.StreamedResponse streamResponse = await MultipartRequestHelper.postData(
      token: groupParams.token, 
      request: multipartRequest, 
      files: groupParams.avatarFile != null ? [groupParams.avatarFile] : [],
      keyName: 'file',
      data: {
        if (groupParams.contactIds.length != 0)
          'contact': groupParams.contactIds.join(','),
        if (groupParams.isPrivate)
          'is_private': groupParams.isPrivate ? 1 : 0,
        'name': groupParams.name,
        'description': groupParams.description,
        'is_private': '0'
      }
    );

    final httpResponse = await http.Response.fromStream(streamResponse);

    if (httpResponse.isSuccess) {
      return ChatEntityModel.fromJson(json.decode(httpResponse.body.toString()));
    } else {
      throw ServerFailure(message: httpResponse.body.toString());
    }
  }
}
