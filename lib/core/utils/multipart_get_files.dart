import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


class MultipartGetFiles {
  
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
}