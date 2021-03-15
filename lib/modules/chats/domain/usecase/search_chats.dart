import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/chat_search_response.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chats_repository.dart';
import 'params.dart';

class SearchChats extends UseCase<ChatMessageResponse, SearchChatParams> {
  final ChatsRepository repository;

  SearchChats(this.repository);

  @override
  Future<Either<Failure, ChatMessageResponse>> call(SearchChatParams params) async {
    return repository.searchChats(
      nextPageURL: params.nextPageURL,
      queryText: params.queryText
    );
  }
}