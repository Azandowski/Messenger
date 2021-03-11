import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:easy_localization/easy_localization.dart';

import 'app/appTheme.dart';
import 'bloc_observer.dart';
import 'core/blocs/authorization/bloc/auth_bloc.dart';
import 'core/blocs/category/bloc/category_bloc.dart';
import 'core/blocs/chat/bloc/bloc/chat_cubit.dart';
import 'core/config/routes.dart';
import 'core/screens/splash_screen.dart';
import 'locator.dart' as serviceLocator;
import 'modules/creation_module/presentation/bloc/contact_bloc/contact_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await serviceLocator.init();
  // initializeDateFormatting('ru', null);

  Bloc.observer = SimpleBlocObserver();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(
    EasyLocalization(
      child: MainApp(),
      supportedLocales: [
        Locale('ru', 'RU'),
        Locale('en', 'US'),
        Locale('kk', 'KZ'),
        Locale('tr', 'TR'),
        Locale('zh', 'CN'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('ru', 'RU'),
    ),
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: serviceLocator.sl<ChatGlobalCubit>()),
        BlocProvider(create: (_) => serviceLocator.sl<CategoryBloc>()),
        BlocProvider(
          create: (_) =>
              serviceLocator.sl<ContactBloc>()..add(ContactFetched()),
        ),
        BlocProvider.value(
          value: serviceLocator.sl<AuthBloc>(),
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
            theme: AppTheme.light,
            navigatorKey: navigatorKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routes: routes,
          );
        },
      ),
    );
  }
}
