import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';

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
    http.StreamedResponse response = await postUserData(
        token: token,
        request: request,
        data: data,
        files: file != null ? [file] : []);

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return true;
    } else {
      throw ServerFailure(message: response.stream.bytesToString().toString());
    }
  }

  Future<http.StreamedResponse> postUserData(
      {@required String token,
      @required http.MultipartRequest request,
      Map data,
      List<File> files}) async {
    
    http.MultipartRequest copyRequest = http.MultipartRequest('POST', Endpoints.updateCurrentUser.buildURL());

    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = 'application/json';

    request.headers.forEach((name, value) {
      copyRequest.headers[name] = value;
    });

    (data ?? {}).keys.forEach((e) {
      request.fields[e] = data[e];
    });
  
    request.files.addAll(await getFilesList(files));
    copyRequest.files.addAll(request.files);

    return copyRequest.send();
  }

  // Returns MultiPart Files
  Future<List<http.MultipartFile>> getFilesList(List<File> files) async {
    List<http.MultipartFile> _files = [];

    for (int i = 0; i < files.length; i++) {
      if (files[i] != null) {
        var stream = new http.ByteStream((files[i].openRead()));
        var length = await files[i].length();
        var date = DateTime.now().millisecondsSinceEpoch.toString();
        var multipartFile = new http.MultipartFile("avatar", stream, length,
            filename: basename(files[i].path + date));
        _files.add(multipartFile);
      }
    }

    return _files;
  }
}
