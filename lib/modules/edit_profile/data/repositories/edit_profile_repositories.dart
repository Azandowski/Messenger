import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../../profile/domain/usecases/profile_params.dart';
import '../../domain/repositories/edit_profile_repositories.dart';
import '../datasources/edit_profile_datasource.dart';

class EditUserRepositoryImpl extends EditUserRepository {
  final EditProfileDataSource editProfileDataSource;
  final NetworkInfo networkInfo;

  EditUserRepositoryImpl(
      {@required this.editProfileDataSource, @required this.networkInfo});

  @override
  Future<Either<Failure, bool>> updateUser(
      EditUserParams editUserParams) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await editProfileDataSource.updateUser(
            file: editUserParams.image,
            data: editUserParams.jsonBody,
            token: editUserParams.token);

        return Right(response);
      } catch (e) {
        return Left(e);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
