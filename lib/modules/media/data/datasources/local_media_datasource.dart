import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

abstract class MediaLocalDataSource {
  Future<File> getImage(ImageSource source);
  Future<List<Asset>> getImagesFromGallery();
  Future<List<File>> getAudio();
}

class MediaLocalDataSourceImpl implements MediaLocalDataSource {
  @override
  Future<File> getImage(source) async {
    var pickedFile = await ImagePicker().getImage(source: source,imageQuality: 10);
    return File(pickedFile.path);
  }

   Future<File> getVideo(source) async {
    var pickedFile = await ImagePicker().getVideo(source: ImageSource.gallery,);

    return File(pickedFile.path);
  }

  @override
  Future<List<Asset>> getImagesFromGallery() async {
    try {
      List<Asset> images = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: false,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      return images;
    } on Exception catch (e) {
    }
  }

  @override
  Future<List<File>> getAudio() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: false, 
      allowedExtensions: ['wav', 'mp3', 'aac', 'wma'],
      type: FileType.custom,
    );
    if(result != null) {
      List<File> files = result.paths.map((path) => File(path)).toList();
      return files;
    } else {
      throw StorageFailure(message: 'Файл не выбран'); 
    }
  }
}
