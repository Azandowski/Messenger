import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


class MultipartRequestHelper {
  /**
   * Converts list of files to MultipartFiles
   * * files => files The list of input files
   * * keyName => field's name in backend
   */
  static Future<List<http.MultipartFile>> getFilesList(
    List<File> files,
    String keyName
  ) async {
    List<http.MultipartFile> _files = [];

    for (int i = 0; i < files.length; i++) {
      if (files[i] != null) {
        var stream = new http.ByteStream((files[i].openRead()));
        var length = await files[i].length();
        var date = DateTime.now().millisecondsSinceEpoch.toString();
        var multipartFile = new http.MultipartFile(keyName, stream, length,
            filename: basename(files[i].path + date));
        _files.add(multipartFile);
      }
    }

    return _files;
  }


  /**
   * Sends MultiPart Request
   * * token => Bearer token of the user
   * * files => files The list of input files
   * * keyName => field's name in backend
   * * data => body of the request,
   */
  static Future<http.StreamedResponse> postData({
    @required String token,
    @required http.MultipartRequest request,
    @required String keyName,
    Map data,
    List<File> files,
  }) async {

    http.MultipartRequest copyRequest = http.MultipartRequest('POST', request.url);

    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = 'application/json';

    request.headers.forEach((name, value) {
      copyRequest.headers[name] = value;
    });

    (data ?? {}).keys.forEach((e) {
      request.fields[e] = data[e].toString();
    });

    copyRequest.fields.addAll(request.fields);
  
    request.files.addAll(await getFilesList(
      files ?? [], keyName
    ));

    copyRequest.files.addAll(request.files);

    return copyRequest.send();
  }
}