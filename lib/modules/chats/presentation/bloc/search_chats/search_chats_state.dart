part of 'search_chats_cubit.dart';

abstract class SearchChatsState extends Equatable {
  SearchChatsState({
    @required this.data
  });

  final ChatMessageResponse data; 

  @override
  List<Object> get props => [data];
}

class SearchChatsLoaded extends SearchChatsState {
  final ChatMessageResponse data; 

  SearchChatsLoaded({
    @required this.data
  }) : super(data: data);

  @override
  List<Object> get props => [data];
}

class SearchChatsLoading extends SearchChatsState {
  final ChatMessageResponse data; 
  final bool isPagination;

  SearchChatsLoading({
    @required this.data,
    @required this.isPagination
  }) : super(data: data);

  @override
  List<Object> get props => [data, isPagination];
}

class SearchChatsError extends SearchChatsState {
  final String message;
  final ChatMessageResponse data; 

  SearchChatsError({
    @required this.message,
    @required this.data
  });

  @override
  List<Object> get props => [
    message,
    data
  ];
}