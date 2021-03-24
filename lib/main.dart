import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/screens/splash_screen.dart';
import 'app/application.dart';
import 'modules/creation_module/presentation/bloc/contact_bloc/contact_bloc.dart';
import 'package:messenger_mobile/core/blocs/audioplayer/bloc/audio_player_bloc.dart';

import 'app/appTheme.dart';
import 'bloc_observer.dart';
import 'core/blocs/authorization/bloc/auth_bloc.dart';
import 'core/blocs/category/bloc/category_bloc.dart';
import 'core/blocs/chat/bloc/bloc/chat_cubit.dart';
import 'core/config/routes.dart';
import 'core/screens/splash_screen.dart';
import 'locator.dart' as serviceLocator;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await serviceLocator.init();
  await EasyLocalization.ensureInitialized();
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
    return BlocProvider(
        create: (context) => ChatGlobalCubit(
          serviceLocator.sl(),
          serviceLocator.sl(),
          serviceLocator.sl(),
        ),
        child: BlocProvider(
            create: (context) => CategoryBloc(
              reorderCategories: serviceLocator.sl(),
              repository: serviceLocator.sl(),
              deleteCategory: serviceLocator.sl(),
              chatGlobalCubit: context.read<ChatGlobalCubit>(),
            ),
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) =>
                      serviceLocator.sl<ContactBloc>()..add(ContactFetched()),
                ),
                BlocProvider(
                  create: (_) => AudioPlayerBloc(),
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
                    navigatorKey: serviceLocator.sl<Application>().navKey,
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: context.deviceLocale,
                    routes: routes,
                  );
                },
              ),
            ),
          ),
      );
  }
}

