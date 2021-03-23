part of 'chats_cubit_cubit.dart';

abstract class ChatsCubitState extends Equatable {
  final int currentTabIndex;

  const ChatsCubitState({
    @required this.currentTabIndex
  });

  @override
  List<Object> get props => [currentTabIndex];
}

class ChatsCubitStateNormal extends ChatsCubitState {
  final int currentTabIndex;
  
  const ChatsCubitStateNormal({
    @required this.currentTabIndex
  }) : super(currentTabIndex: currentTabIndex);

  @override
  List<Object> get props => [currentTabIndex];
}

class ChatsCubitSelectedOne extends ChatsCubitState {
  final int currentTabIndex;
  final int selectedChatIndex;

  ChatsCubitSelectedOne({ 
    @required this.currentTabIndex,
    @required this.selectedChatIndex,
  }) : super(
    currentTabIndex: currentTabIndex
  );

  @override
  List<Object> get props => [selectedChatIndex, currentTabIndex];  
}