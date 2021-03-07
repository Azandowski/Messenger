import 'package:flutter/foundation.dart';

import '../../../../core/services/network/network_info.dart';
import '../../domain/repositories/profile_respository.dart';
import '../datasources/profile_datasource.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileDataSource profileDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    @required this.profileDataSource, 
    @required this.networkInfo
  });
}
