
import 'dart:async';
import 'dart:io';

abstract class WallpaperRepository {  

  Stream<File> get streamFile;

  Future<void> setLocalWallpaper(File file); 

  Future<void> getWallpaper();
}
