import 'dart:async';
import 'dart:io';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:path_provider/path_provider.dart';

abstract class WallpaperDataSource {

  Future<File> setLocalWallpaper(File file); 

  Future<File> getWallpaper();
}

class WallpaperDataSourceImpl implements WallpaperDataSource {

  @override
  Future<File> getWallpaper() async {
    Directory appDocumentsDirectory = await getTemporaryDirectory(); 
    String appDocumentsPath = appDocumentsDirectory.path; 
    String filePath = '$appDocumentsPath/wallpaper.png';
    try {
      File output = File(filePath);
      return output;
    } catch (e) {
      throw StorageFailure(message: 'no file');
    }
  }

  @override
  Future<File> setLocalWallpaper(File file) async {
    Directory appDocumentsDirectory = await getTemporaryDirectory(); 
    String appDocumentsPath = appDocumentsDirectory.path; 
    String filePath = '$appDocumentsPath/wallpaper.png';
    File oldImage = File(filePath);
    if(await oldImage.exists()) {
      oldImage.delete();
    }
    imageCache.clear();
    File newImage = await file.copy(filePath);
    return newImage;
  }
}
