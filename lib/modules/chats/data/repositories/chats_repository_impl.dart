import 'package:flutter/foundation.dart';
import '../../../../core/services/network/network_info.dart';
import '../../domain/repositories/chats_repository.dart';
import '../datasource/chats_datasource.dart';

class ChatsRepositoryImpl extends ChatsRepository {
  final ChatsDataSource chatsDataSource;
  final NetworkInfo networkInfo;

  ChatsRepositoryImpl(
      {@required this.chatsDataSource, @required this.networkInfo});

 
}
