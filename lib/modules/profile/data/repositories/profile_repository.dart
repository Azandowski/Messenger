import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/modules/profile/data/datasources/profile_datasource.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:messenger_mobile/modules/profile/domain/repositories/profile_respository.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/get_user.dart';

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