import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/modules/chats/data/datasource/chats_datasource.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/usecases/params.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';

class ChatsRepositoryImpl extends ChatsRepository {
  final ChatsDataSource chatsDataSource; 
  final NetworkInfo networkInfo;

  ChatsRepositoryImpl({
    @required this.chatsDataSource, 
    @required this.networkInfo
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories(GetCategoriesParams getCategoriesParams) async {
    if (await networkInfo.isConnected) {
      try {   
        final categories = await chatsDataSource.getCategories(getCategoriesParams.token);
        return Right(categories);
      } catch (e) {
        return Left(e);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}