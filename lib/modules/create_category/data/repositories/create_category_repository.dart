import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../../chats/domain/entities/category.dart';
import '../../domain/repositories/create_category_repository.dart';
import '../../domain/usecases/params.dart';
import '../datasources/create_category_datasource.dart';

class CreateCategoryRepositoryImpl extends CreateCategoryRepository {
  final CreateCategoryDataSource createCategoryDataSource;
  final NetworkInfo networkInfo;

  CreateCategoryRepositoryImpl({
    @required this.createCategoryDataSource, 
    @required this.networkInfo
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> createCategory(CreateCategoryParams createCategoryParams) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await createCategoryDataSource.createCategory(
          file: createCategoryParams.avatarFile, 
          name: createCategoryParams.name, 
          token: createCategoryParams.token,
          chatIds: createCategoryParams.chatIds
        );
        
        return Right(response);
      } catch (e) {
        return Left(e);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}