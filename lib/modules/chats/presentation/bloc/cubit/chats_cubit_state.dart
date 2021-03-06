part of 'chats_cubit_cubit.dart';

abstract class ChatsCubitState extends Equatable {
  final int currentTabIndex;
  final File wallpaperFile;

  const ChatsCubitState({
    @required this.currentTabIndex,
    this.wallpaperFile
  });

  @override
  List<Object> get props => [currentTabIndex, wallpaperFile];
}

class ChatsCubitStateNormal extends ChatsCubitState {
  final int currentTabIndex;
  final File wallpaperFile;
  
  const ChatsCubitStateNormal({
    @required this.currentTabIndex,
    this.wallpaperFile
  }) : super(currentTabIndex: currentTabIndex, wallpaperFile: wallpaperFile);

  @override
  List<Object> get props => [currentTabIndex, wallpaperFile];
}

class ChatsCubitSelectedOne extends ChatsCubitState {
  final int currentTabIndex;
  final int selectedChatIndex;
  final File wallpaperFile;

  ChatsCubitSelectedOne({ 
    @required this.currentTabIndex,
    @required this.selectedChatIndex,
    this.wallpaperFile
  }) : super(
    currentTabIndex: currentTabIndex, wallpaperFile: wallpaperFile
  );

  @override
  List<Object> get props => [selectedChatIndex, currentTabIndex, wallpaperFile];  
}