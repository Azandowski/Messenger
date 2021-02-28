import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/core/blocs/chat/bloc/bloc/chat_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/blocs/authorization/bloc/auth_bloc.dart';
import 'core/blocs/category/bloc/category_bloc.dart';
import 'core/config/auth_config.dart';
import 'core/services/network/Endpoints.dart';
import 'core/services/network/network_info.dart';
import 'core/utils/date_helper.dart';
import 'modules/authentication/data/datasources/local_authentication_datasource.dart';
import 'modules/authentication/data/datasources/remote_authentication_datasource.dart';
import 'modules/authentication/data/repositories/authentication_repository_impl.dart';
import 'modules/authentication/domain/repositories/authentication_repository.dart';
import 'modules/authentication/domain/usecases/create_code.dart';
import 'modules/authentication/domain/usecases/get_current_user.dart';
import 'modules/authentication/domain/usecases/get_token.dart';
import 'modules/authentication/domain/usecases/login.dart';
import 'modules/authentication/domain/usecases/logout.dart';
import 'modules/authentication/domain/usecases/save_token.dart';
import 'modules/authentication/presentation/bloc/index.dart';
import 'modules/category/data/datasources/category_datasource.dart';
import 'modules/category/data/repositories/category_repository.dart';
import 'modules/category/domain/repositories/category_repository.dart';
import 'modules/category/domain/usecases/create_category.dart';
import 'modules/category/domain/usecases/get_categories.dart';
import 'modules/category/presentation/create_category_main/bloc/create_category_cubit.dart';
import 'modules/chats/data/datasource/chats_datasource.dart';
import 'modules/chats/data/repositories/chats_repository_impl.dart';
import 'modules/chats/domain/repositories/chats_repository.dart';
import 'modules/chats/domain/usecase/get_chats.dart';
import 'modules/chats/presentation/bloc/cubit/chats_cubit_cubit.dart';
import 'modules/media/data/datasources/local_media_datasource.dart';
import 'modules/media/data/repositories/media_repository_impl.dart';
import 'modules/media/domain/repositories/media_repository.dart';
import 'modules/media/domain/usecases/get_image.dart';
import 'modules/profile/data/datasources/profile_datasource.dart';
import 'modules/profile/data/repositories/profile_repository.dart';
import 'modules/profile/domain/repositories/profile_respository.dart';
import 'modules/profile/domain/usecases/get_user.dart';
import 'modules/profile/presentation/bloc/index.dart';
import 'modules/profile/presentation/bloc/profile_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! FEATURES
  //Authentication

  //BLoc
  sl.registerFactory(
    () => AuthenticationBloc(
      login: sl(),
    ),
  );

  sl.registerFactory(() => ProfileCubit(getUser: sl()));
  sl.registerFactory(() => ChatsCubit(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetToken(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => CreateCode(sl()));
  sl.registerLazySingleton(() => GetUser(sl()));
  sl.registerLazySingleton(() => GetCategories(repository: sl()));
  sl.registerLazySingleton(() => SaveToken(sl()));
  sl.registerLazySingleton(() => GetChats(sl()));

  // Repository

  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositiryImpl(
      getCategories: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(profileDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<ChatsRepository>(
    () => ChatsRepositoryImpl(chatsDataSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<AuthenticationLocalDataSource>(
    () => AuthenticationLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => AuthenticationRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<ProfileDataSource>(
      () => ProfileDataSourceImpl(client: sl()));

  sl.registerLazySingleton<ChatsDataSource>(
      () => ChatsDataSourceImpl(client: sl()));
 
  // CreateCategory

  //Bloc 
  sl.registerFactory(() => CreateCategoryCubit(createCategory: sl(), getImageUseCase: sl()));

  //Use Cases
  sl.registerLazySingleton(() => CreateCategoryUseCase(sl()));
  sl.registerLazySingleton(() => GetImage(sl()));

  // Repoitory
  sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(categoryDataSource: sl(), networkInfo: sl()));
  
  // Data Sources
  
   sl.registerLazySingleton<CategoryDataSource>(
      () => CategoryDataSourceImpl(
        multipartRequest: http.MultipartRequest('POST', Endpoints.createCategory.buildURL()),
        client: sl())
    );



  //! Core

  //BLoc

  sl.registerFactory(
    () => AuthBloc(
      authRepositiry: sl(),
      logoutUseCase: sl(),
    ),
  );

   sl.registerFactory(
    () => ChatBloc(
      sl(),
    ),
  );

  sl.registerFactory(
    () => CategoryBloc(
      repository: sl(),
    ),
  );

  // local storage
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // network online/offline mode
  sl.registerLazySingleton(() => DataConnectionChecker());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerLazySingleton(() => AuthConfig());

  sl.registerLazySingleton(() => DateHelper());

  sl.registerLazySingleton(() => http.Client());


  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Repositories
  sl.registerLazySingleton<MediaRepository>(
    () => MediaRepositoryImpl(
      mediaLocalDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<ChatsRepository>(
      () => ChatsRepositoryImpl(chatsDataSource: sl(), networkInfo: sl()));
  

  // Data sources

  sl.registerLazySingleton<MediaLocalDataSource>(
    () => MediaLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<ChatsDataSource>(
    () => ChatsDataSourceImpl(client: sl()),
  );
}
