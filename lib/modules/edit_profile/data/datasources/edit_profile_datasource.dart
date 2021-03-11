import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/core/utils/error_handler.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/multipart_request_helper.dart';

abstract class EditProfileDataSource {
  Future<bool> updateUser(
      {@required File file,
      @required Map<String, String> data,
      @required String token});
}

class EditProfileDataSourceImpl implements EditProfileDataSource {
  final http.MultipartRequest request;

  EditProfileDataSourceImpl({@required this.request});

  @override
  Future<bool> updateUser(
      {File file, Map<String, String> data, String token}) async {
    http.StreamedResponse response = await MultipartRequestHelper.postData(
        token: token,
        request: request,
        data: data,
        files: file != null ? [file] : [],
        keyName: 'avatar');

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return true;
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(
              response.stream.bytesToString().toString()));
    }
  }
}
