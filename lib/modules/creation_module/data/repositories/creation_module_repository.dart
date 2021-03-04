
import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/modules/creation_module/data/datasources/creation_module_datasource.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_response.dart';
import 'package:messenger_mobile/modules/creation_module/domain/repositories/creation_module_repository.dart';

class CreationModuleRepositoryImpl implements CreationModuleRepository {
  final NetworkInfo networkInfo; 
  final CreationModuleDataSource dataSource;

  CreationModuleRepositoryImpl({
   @required this.dataSource,
   @required this.networkInfo,
  });
  @override
  Future<Either<Failure, ContactResponse>> fetchContacts(Pagination pagination) async {
    if (await networkInfo.isConnected) {
      try {
        final ContactResponse contactResponse =
            await dataSource.fetchContacts(pagination);
        return Right(contactResponse);
      } on ServerFailure catch(e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      throw ServerFailure(message: 'no_internet');
    }
  
  }
}
