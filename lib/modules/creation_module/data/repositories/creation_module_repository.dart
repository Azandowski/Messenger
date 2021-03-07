
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../../../core/utils/pagination.dart';
import '../../domain/repositories/creation_module_repository.dart';
import '../datasources/creation_module_datasource.dart';
import '../models/contact_response.dart';

class CreationModuleRepositoryImpl implements CreationModuleRepository {
  final NetworkInfo networkInfo; 
  final CreationModuleDataSource dataSource;

  CreationModuleRepositoryImpl({
   @required this.dataSource,
   @required this.networkInfo,
  });
  @override
  Future<Either<Failure, ContactResponse>> fetchContacts(Pagination pagination) async {
      try {
        final ContactResponse contactResponse =
            await dataSource.fetchContacts(pagination);
        return Right(contactResponse);
      } on ServerFailure catch(e) {
        return Left(ServerFailure(message: e.message));
      }
  }
}
