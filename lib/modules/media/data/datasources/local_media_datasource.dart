import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

abstract class MediaLocalDataSource {
  Future<File> getImage(ImageSource source);
  Future<List<Asset>> getImagesFromGallery();
}

class MediaLocalDataSourceImpl implements MediaLocalDataSource {
  @override
  Future<File> getImage(source) async {
    var pickedFile = await ImagePicker().getImage(source: source,imageQuality: 10);
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
}
