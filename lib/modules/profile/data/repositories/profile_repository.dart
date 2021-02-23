import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_respository.dart';
import '../../domain/usecases/profile_params.dart';
import '../datasources/profile_datasource.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileDataSource profileDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl(
      {@required this.profileDataSource, @required this.networkInfo});

  @override
  Future<Either<Failure, User>> getUser(GetUserParams getUserParams) async {
    if (await networkInfo.isConnected) {
      try {
        final user =
            await profileDataSource.getCurrentUser(getUserParams.token);
        return Right(user);
      } catch (e) {
        return Left(e);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
