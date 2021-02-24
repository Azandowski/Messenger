import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:path/path.dart';

abstract class CreateCategoryDataSource {
  Future<List<CategoryEntity>> createCategory({
    @required File file,
    @required String name,
    List<int> chatIds,
  });
}


class CreateCategoryDataSourceImpl implements CreateCategoryDataSource {
  
  final http.MultipartRequest multipartRequest;

  CreateCategoryDataSourceImpl({
    @required this.multipartRequest
  });
  
  @override
  Future<List<CategoryEntity>> createCategory({File file, String name, List<int> chatIds}) {
    // TODO: implement createCategory
    throw UnimplementedError();
  } 
}

extension CreateCategoryDataSourceImplExtension on CreateCategoryDataSourceImpl {
  Future<List<http.MultipartFile>> getFilesList(
    List<File> files
  ) async {
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
