import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/category/data/datasources/category_datasource.dart';
import 'package:messenger_mobile/modules/category/domain/repositories/category_repository.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/usecases/params.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../../chats/domain/entities/category.dart';

class CreateCategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource createCategoryDataSource;
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


  @override
  StreamController<List<CategoryEntity>> categoryListController = StreamController<List<CategoryEntity>>.broadcast();

 @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories(
      GetCategoriesParams getCategoriesParams) async {
    if (await networkInfo.isConnected) {
      try {
        final categories =
            await createCategoryDataSource.getCategories(getCategoriesParams.token);
        categoryListController.add(categories);
        return Right(categories);
      } catch (e) {
        return Left(e);
      }
    } else {
      return Left(ConnectionFailure()); 
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> deleteCategory(int id) async{
     if (await networkInfo.isConnected) {
      try {
        final category =
            await createCategoryDataSource.deleteCatefory(id);
        return Right(category);
      } catch (e) {
        return Left(e);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
  
}