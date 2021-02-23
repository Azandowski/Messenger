import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/bloc_observer.dart';
import 'package:messenger_mobile/core/authorization/bloc/auth_bloc.dart';
import 'app/appTheme.dart';
import 'core/screens/splash_screen.dart';
import 'locator.dart' as serviceLocator;
import 'core/config/routes.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await serviceLocator.init();
  Bloc.observer = SimpleBlocObserver();
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
    return BlocProvider.value(
      value: serviceLocator.sl<AuthBloc>(),
      child: MaterialApp(
        home: SplashScreen(),
        theme: AppTheme.light,
        navigatorKey: navigatorKey,
        routes: routes,
      ),
    );
  }
}
