part of 'wallpaper_bloc_bloc.dart';

abstract class WallpaperBlocEvent extends Equatable {
  const WallpaperBlocEvent();

  @override
  List<Object> get props => [];
}

class FileAdded extends WallpaperBlocEvent{
  final File newFile;
  FileAdded(this.newFile);
}

class ChangeFile extends WallpaperBlocEvent{
  final File newFile;
  ChangeFile(this.newFile);
}