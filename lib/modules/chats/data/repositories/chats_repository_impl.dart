import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/usecases/params.dart';
import '../../domain/repositories/chats_repository.dart';
import '../datasource/chats_datasource.dart';

class ChatsRepositoryImpl extends ChatsRepository {
  final ChatsDataSource chatsDataSource;
  final NetworkInfo networkInfo;

  ChatsRepositoryImpl(
      {@required this.chatsDataSource, @required this.networkInfo});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories(
      GetCategoriesParams getCategoriesParams) async {
    if (await networkInfo.isConnected) {
      try {
        final categories =
            await chatsDataSource.getCategories(getCategoriesParams.token);
        return Right(categories);
      } catch (e) {
        return Left(e);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
