import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/core/blocs/bloc/auth_bloc.dart';
import 'modules/authentication/data/datasources/local_authentication_datasource.dart';
import 'modules/authentication/data/datasources/remote_authentication_datasource.dart';
import 'modules/authentication/data/repositories/authentication_repository_impl.dart';
import 'modules/authentication/domain/repositories/authentication_repository.dart';
import 'modules/authentication/domain/usecases/create_code.dart';
import 'modules/authentication/domain/usecases/get_token.dart';
import 'modules/authentication/domain/usecases/login.dart';
import 'modules/authentication/presentation/bloc/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/auth_config.dart';
import 'core/services/network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! FEATURES
  //Authentication

  //BLoc
  sl.registerFactory(
    () => AuthenticationBloc(
      createCode: sl(),
      login: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetToken(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => CreateCode(sl()));

  // Repository
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositiryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthenticationLocalDataSource>(
    () => AuthenticationLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => AuthenticationRemoteDataSourceImpl(client: sl()),
  );

  //! Core

  //BLoc

  sl.registerFactory(
    () => AuthBloc(
      getToken: sl(),
    ),
  );

  // local storage
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // network online/offline mode
  sl.registerLazySingleton(() => DataConnectionChecker());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerLazySingleton(() => AuthConfig());

  sl.registerLazySingleton(() => http.Client());
}
