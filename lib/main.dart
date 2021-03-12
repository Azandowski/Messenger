import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:messenger_mobile/core/screens/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'app/appTheme.dart';
import 'bloc_observer.dart';
import 'core/blocs/authorization/bloc/auth_bloc.dart';
import 'core/blocs/category/bloc/category_bloc.dart';
import 'core/blocs/chat/bloc/bloc/chat_cubit.dart';
import 'core/config/routes.dart';
import 'locator.dart' as serviceLocator;
import 'modules/creation_module/presentation/bloc/contact_bloc/contact_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

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
            locale: context.deviceLocale,
            routes: routes,
          );
        },
      ),
    );
  }
}

class TestSoccet extends StatefulWidget {
  @override
  _TestSoccetState createState() => _TestSoccetState();
}

class _TestSoccetState extends State<TestSoccet> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
    
    IO.Socket socket;
    Echo echo;

    void init () {
      Map headers = { 'Authorization': 'Bearer 1011|T3aLtv7UidhsByAMFvOjm0vJ0qAPc71UYbJjDc8k'};

      socket = IO.io('https://aio-test-vps.kulenkov-group.kz:6002',
        IO.OptionBuilder().setExtraHeaders(new Map<String, dynamic>.from(headers))
          .setTransports(['websocket']).build());

        echo = new Echo({
          'broadcaster': 'socket.io',
          'client': socket,
          'auth': {
            'headers': headers
          },
          'host':'https://aio-test-vps.kulenkov-group.kz:6002'
        });
       socket.connect();

       echo.connect();

       echo.channel('messages.44').listen(
        '.messages.44', 
        (updates) {
          print(updates);
        }
      );
      echo.join('messages.44')
      .joining((user) {
        print('some user');
        print(user);
      }).leaving((user) {
        print('i quit');
        print(user);
      });
      
      socket.onConnect((data) {
        print('connected');
      });
      socket.emit('online');

      // socket.onDisconnect((data) {
      //   print('disconnect');
      // }); 

      // socket.onError((data) {
      //   print('some error here');
      // });

     

    }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}