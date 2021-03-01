import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/usecases/params.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../../chats/domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/params.dart';
import '../datasources/category_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource categoryDataSource;
  final NetworkInfo networkInfo;

  CategoryRepositoryImpl({
    @required this.categoryDataSource, 
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> createCategory(CreateCategoryParams createCategoryParams) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await categoryDataSource.createCategory(
          file: createCategoryParams.avatarFile, 
          name: createCategoryParams.name, 
          token: createCategoryParams.token,
          chatIds: createCategoryParams.chatIds,
          isCreate: createCategoryParams.isCreate,
          categoryID: createCategoryParams.categoryID
        );
        
        categoryListController.add(response);
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
    GetCategoriesParams getCategoriesParams
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await categoryDataSource.getCategories(getCategoriesParams.token);
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
  Future<Either<Failure, CategoryEntity>> deleteCategory(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await categoryDataSource.deleteCatefory(id);
        return Right(response);
      } catch (e) {
        return Left(e);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, NoParams>> transferChats(List<int> chatsIDs, int categoryID) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await categoryDataSource.transferChats(chatsIDs, categoryID);
        return Right(NoParams());
      } catch (e) {
        return Left(e);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}