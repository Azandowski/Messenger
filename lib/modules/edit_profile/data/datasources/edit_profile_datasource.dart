import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

abstract class EditProfileDataSource {
  Future<bool> updateUser ({
    @required File file,
    @required Map<String, String> data,
    @required String token
  });
}

class EditProfileDataSourceImpl implements EditProfileDataSource {
  final http.MultipartRequest request;

  EditProfileDataSourceImpl({
    @required this.request
  });

  @override
  Future<bool> updateUser({File file, Map<String, String> data, String token}) {
    throw UnimplementedError();
  }

  
  Future<http.StreamedResponse> postUserData ({
    @required String token, 
    @required http.MultipartRequest request,
    Map data, 
    List<File> files
  }) async {
    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = 'application/json';

    (data ?? {}).keys.forEach((e) { request.fields[e] = data[e]; });

    request.files.addAll(await getFilesList(files));

    return request.send();
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

  
  // @override
  // Future<User> getCurrentUser(String token) async {
  //   http.Response response = await client.post(
  //     Endpoints.getCurrentUser.buildURL(), 
  //     headers: Endpoints.getCurrentUser.getHeaders(token: token),
  //     body: json.encode({ 'application_id': '1' })
  //   );

  //   if (response.statusCode >= 200 && response.statusCode <= 299) {
  //     return UserModel.fromJson(json.decode(response.body));
  //   } else {
  //     throw ServerFailure(message: response.body.toString());
  //   }
  // }
}