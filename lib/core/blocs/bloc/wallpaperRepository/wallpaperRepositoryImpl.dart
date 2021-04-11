import 'dart:async';
import 'dart:io';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:meta/meta.dart';
import 'package:messenger_mobile/core/blocs/bloc/wallpaperRepository/dataSource/localDataSource.dart';
import 'package:messenger_mobile/core/blocs/bloc/wallpaperRepository/wallpaperRepository.dart';

class WallpaperRepositoryImpl implements WallpaperRepository{
  final WallpaperDataSource dataSource;
  WallpaperRepositoryImpl({@required this.dataSource});

  final _controller = StreamController<File>();

  @override
  Stream<File> get streamFile async* {
    yield* _controller.stream;
  }

  @override
  Future<void> setLocalWallpaper(File file) async{
    File streamFile = await dataSource.setLocalWallpaper(file);
    _controller.add(streamFile);
  }

  @override
  Future<void> getWallpaper() async{
    try{
     File file = await dataSource.getWallpaper();
     _controller.add(file);
    } on StorageFailure{
      //Nothing to do
    }
  
  }

}