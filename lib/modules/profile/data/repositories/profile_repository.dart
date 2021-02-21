import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_respository.dart';
import '../../domain/usecases/get_user.dart';
import '../datasources/profile_datasource.dart';

class ProfileRepositiryImpl extends ProfileRepository {
  final ProfileDataSource profileDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositiryImpl({
    @required this.profileDataSource, 
    @required this.networkInfo
  });

  @override
  Future<Either<Failure, User>> getUser(GetUserParams getUserParams) async {
    try {   
      final token = await profileDataSource.getCurrentUser(getUserParams.token);
      return Right(token);
    } catch (e) {
      return Left(e);
    }
  }
}