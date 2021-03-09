import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:messenger_mobile/core/screens/splash_screen.dart';
import 'app/appTheme.dart';
import 'bloc_observer.dart';
import 'core/blocs/authorization/bloc/auth_bloc.dart';
import 'core/blocs/category/bloc/category_bloc.dart';
import 'core/blocs/chat/bloc/bloc/chat_cubit.dart';
import 'core/config/routes.dart';
import 'locator.dart' as serviceLocator;
import 'modules/creation_module/presentation/bloc/contact_bloc/contact_bloc.dart';


final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await serviceLocator.init();
  initializeDateFormatting('ru', null);

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
        BlocProvider.value(value: serviceLocator.sl<ChatGlobalCubit>()),
        BlocProvider(create: (_) => serviceLocator.sl<CategoryBloc>()),
        BlocProvider(create: (_) => serviceLocator.sl<ContactBloc>()..add(ContactFetched()),),
        BlocProvider.value(value: serviceLocator.sl<AuthBloc>()),
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

// class TestSoccet extends StatefulWidget {
//   @override
//   _TestSoccetState createState() => _TestSoccetState();
// }

// class _TestSoccetState extends State<TestSoccet> {

// StreamSocket streamSocket = StreamSocket();

// Echo echo;

// void connectAndListen(){

// IO.Socket socket = IO.io('https://aio-test-vps.kulenkov-group.kz:6002',
//       IO.OptionBuilder().setExtraHeaders({'Authorization': 'Bearer 991|JplDR2OggW9kxLY1OFvNqSvelyohP2NfmyAzJghZ'})
//       .setTransports(['websocket']).build());
      
//     socket.onConnect((_) {
//      print('connect');
//     });

// echo = new Echo({
//   'broadcaster': 'socket.io',
//   'client': socket,
//   'auth': {
//   'headers': {
//     'Authorization': 'Bearer 991|JplDR2OggW9kxLY1OFvNqSvelyohP2NfmyAzJghZ'
//   }
//   }
// });

// echo.connect();

// echo.join('messages.54')
//   .here((data) {
//     print('shit');
//     print(data);
//   }).joining((data) {
//     print(data);
//   }).leaving((data) {
//     print(data);
//   });

//   echo.channel('laravel_database_messages.54').listen('.messages.54', (shit){
//      print(shit);
//   });
//   echo.leave('laravel_database_messages.54');

// }

//  @override
//   void initState() {
//     super.initState();
//     connectAndListen();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(),
      
//     );
//   }
// }
