
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../../core/utils/pagination.dart';
import '../../domain/entities/contact.dart';
import '../../domain/repositories/creation_module_repository.dart';
import '../datasources/creation_module_datasource.dart';

class CreationModuleRepositoryImpl implements CreationModuleRepository {
  final NetworkInfo networkInfo; 
  final CreationModuleDataSource dataSource;

  CreationModuleRepositoryImpl({
   @required this.dataSource,
   @required this.networkInfo,
  });
  @override
  Future<Either<Failure, PaginatedResult<ContactEntity>>> fetchContacts(Pagination pagination) async {
    try {
      final PaginatedResult<ContactEntity> contactResponse =
          await dataSource.fetchContacts(pagination);
      return Right(contactResponse);
    } on ServerFailure catch(e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
