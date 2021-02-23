import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class MediaLocalDataSource {
  Future<File> getImage(ImageSource source);
}

class MediaLocalDataSourceImpl implements MediaLocalDataSource {
  @override
  Future<File> getImage(source) async {
    var pickedFile = await ImagePicker().getImage(source: source);
    return File(pickedFile.path);
  }
}
