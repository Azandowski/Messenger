import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:messenger_mobile/core/blocs/bloc/wallpaperRepository/wallpaperRepository.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';

part 'wallpaper_bloc_event.dart';

class WallpaperBloc extends Bloc<WallpaperBlocEvent, File> {
  final WallpaperRepository repository;

  WallpaperBloc({@required this.repository}) : super(null){
    repository.getWallpaper();
    repository.streamFile.listen((file) {
      this.add(FileAdded(file));
    });
  }

  @override
  Stream<File> mapEventToState(
    WallpaperBlocEvent event,
  ) async* {
    if(event is FileAdded){
      yield event.newFile;
    }else if(event is ChangeFile){
      repository.setLocalWallpaper(event.newFile);
    }
  }
}
