import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/modules/chats/presentation/bloc/cubit/chats_cubit_cubit.dart';

import 'app/appTheme.dart';
import 'bloc_observer.dart';
import 'core/blocs/authorization/bloc/auth_bloc.dart';
import 'core/config/routes.dart';
import 'core/screens/splash_screen.dart';
import 'locator.dart' as serviceLocator;
import 'modules/chats/presentation/bloc/cubit/chats_cubit_cubit.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: serviceLocator.sl<ChatsCubit>()),
        BlocProvider.value(value: serviceLocator.sl<AuthBloc>())
      ],
      child: MaterialApp(
        home: SplashScreen(),
        theme: AppTheme.light,
        navigatorKey: navigatorKey,
        routes: routes,
      )
    );
  }
}
