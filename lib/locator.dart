import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger_mobile/core/network/network_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async { 
  
  // local storage
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // network online/offline mode
  sl.registerLazySingleton(() => DataConnectionChecker());

  sl.registerLazySingleton(() => NetworkInfoImpl(DataConnectionChecker()));
}
