import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'core/services/network/NetworkingService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // local storage
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // network online/offline mode
  sl.registerLazySingleton(() => DataConnectionChecker());

  sl.registerLazySingleton(() => NetworkInfoImpl(DataConnectionChecker()));

  sl.registerLazySingleton(() => AuthConfig());

  sl.registerLazySingleton(() => http.Client());

  // Networking Service
  sl.registerLazySingleton(() => NetworkingService(httpClient: sl()));
}
