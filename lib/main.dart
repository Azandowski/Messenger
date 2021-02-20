import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/authentication/data/datasources/local_authentication_datasource.dart';
import 'package:messenger_mobile/modules/authentication/data/datasources/remote_authentication_datasource.dart';
import 'package:messenger_mobile/modules/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/get_token.dart';
import 'package:messenger_mobile/modules/profile/presentation/pages/profile_page.dart';
import 'locator.dart' as serviceLocator;
import 'modules/authentication/bloc/index.dart';


final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await serviceLocator.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(BlocProvider<AuthenticationBloc>(
    create: (_) => AuthenticationBloc(
      getToken: GetToken(AuthenticationRepositiryImpl(
        remoteDataSource: AuthenticationRemoteDataSourceImpl(),
        networkInfo: sl<NetworkInfoImpl>(),
        localDataSource: AuthenticationLocalDataSourceImpl()
      ))
    )..add(AppStarted()),
    child: MainApp(),
  ));
}


class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO: Put here Splash screen
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return ProfilePage();
          } else {
            return Container(
              height: 500,
              color: Colors.brown
            );
          }
        },
      ),
      navigatorKey: navigatorKey);
  }
}
