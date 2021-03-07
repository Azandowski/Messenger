
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../../../core/utils/http_response_extension.dart';
import '../../../../core/utils/multipart_request_helper.dart';
import '../../domain/usecases/params.dart';
abstract class ChatGroupRemoteDataSource {
  Future<bool> createChatGroup({
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
  Future<bool> createChatGroup({CreateChatGroupParams groupParams}) async {
    var url = groupParams.isCreate ? Endpoints.createGroupChat.buildURL() : Endpoints.updateCategory.buildURL(urlParams: ['1']);
    multipartRequest = http.MultipartRequest('POST', url);

    http.StreamedResponse streamResponse = await MultipartRequestHelper.postData(
      token: groupParams.token, 
      request: multipartRequest, 
      files: groupParams.avatarFile != null ? [groupParams.avatarFile] : [],
      keyName: 'file',
      data: {
        'contact': groupParams.contactIds.join(','),
        'name': groupParams.name,
        'description': groupParams.description,
      }
    );

    final httpResponse = await http.Response.fromStream(streamResponse);

    if (httpResponse.isSuccess) {
      return true;
    } else {
      throw ServerFailure(message: httpResponse.body.toString());
    }
  }
}
