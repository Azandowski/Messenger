import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/modules/edit_profile/data/datasources/edit_profile_datasource.dart';
import 'package:messenger_mobile/modules/edit_profile/domain/repositories/edit_profile_repositories.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/profile_params.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';

class EditUserRepositoryImpl extends EditUserRepository {
  
  final EditProfileDataSource editProfileDataSource;
  final NetworkInfo networkInfo;

  EditUserRepositoryImpl({
    @required this.editProfileDataSource, 
    @required this.networkInfo
  });

  @override
  Future<Either<Failure, bool>> updateUser(EditUserParams editUserParams) async {
    if (await networkInfo.isConnected) { 
      try {    
        final response = await editProfileDataSource.updateUser(
          file: editUserParams.image, data: editUserParams.jsonBody, token: editUserParams.token
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