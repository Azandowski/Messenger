import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart';

class MultipartRequestHelper {
  /**
   * Converts list of files to MultipartFiles
   * * files => files The list of input files
   * * keyName => field's name in backend
   */
  static Future<List<http.MultipartFile>> getFilesList(
    List<File> files,
    List<String> keyName
  ) async {
    List<http.MultipartFile> _files = [];

    for (int i = 0; i < files.length; i++) {
      if (files[i] != null) {
        var stream = new http.ByteStream((files[i].openRead()));
        var length = await files[i].length();
        var date = DateTime.now().millisecondsSinceEpoch.toString();
        var multipartFile = new http.MultipartFile(keyName[i], stream, length,
            filename: basename(files[i].path + date));
        _files.add(multipartFile);
      }
    }

    return _files;
  }

  /**
   * Converts list of assets to MultipartFiles
   * * assets => assets The list of input assets
   * * keyName => field's name in backend
   */
  static Future<List<http.MultipartFile>> getAssetsList(
    List<Asset> assets,
    List<String> keyName
  ) async {
    List<http.MultipartFile> _files = [];

    for (int i = 0; i < assets.length; i++) {
      if (assets[i] != null) {
        ByteData byteData = await assets[i].getByteData(quality: 10);
        List<int> imageData = byteData.buffer.asUint8List();
        http.MultipartFile multipartFile = MultipartFile.fromBytes(
          keyName[i],
          imageData,
          filename: assets[i].name,
        );
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
   * * assets => assets for uploading
   */
  static Future<http.StreamedResponse> postData({
    @required String token,
    @required http.MultipartRequest request,
    @required List<String> keyName,
    StreamController<double> uploadStreamCtrl,
    Map data,
    List<File> files,
    List<Asset> assets,
  }) async {

    http.MultipartRequest copyRequest = MultipartRequest(
      'POST',
      request.url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        if (uploadStreamCtrl != null) {
          uploadStreamCtrl.add(progress);
        }
      },
    );

    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = 'application/json';

    request.headers.forEach((name, value) {
      copyRequest.headers[name] = value;
    });

    request.fields.clear();

    (data ?? {}).keys.forEach((e) {
      request.fields[e] = data[e].toString();
    });

    copyRequest.fields.addAll(request.fields);
    
    if (files != null && files.length > 0) {
      copyRequest.files.addAll(await getFilesList(
        files, keyName
      ));
    } else if (assets != null && assets.length > 0) {
      copyRequest.files.addAll(await getAssetsList(
        assets ?? [], keyName
      ));
    }
    return copyRequest.send();
  }
}


class MultipartRequest extends http.MultipartRequest {
  /// Creates a new [MultipartRequest].
  MultipartRequest(
    String method,
    Uri url, {
    this.onProgress,
  }) : super(method, url);

  final void Function(int bytes, int totalBytes) onProgress;

  /// Freezes all mutable fields and returns a single-subscription [ByteStream]
  /// that will emit the request body.
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = this.contentLength;
    int bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        onProgress(bytes, total);
        sink.add(data);
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}
