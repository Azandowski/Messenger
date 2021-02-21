import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/appTheme.dart';
import 'core/screens/splash_screen.dart';
import 'modules/authentication/presentation/bloc/authentication_bloc.dart';
import 'modules/authentication/presentation/bloc/index.dart';
import 'locator.dart' as serviceLocator;
import 'package:messenger_mobile/core/config/routes.dart';


final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await serviceLocator.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator.sl<AuthenticationBloc>(),
      child: MaterialApp(
        home: SplashScreen(),
        theme: AppTheme.light,
        navigatorKey: navigatorKey,
        routes: routes,
      ),
    );
  }
}
