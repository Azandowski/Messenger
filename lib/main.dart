import 'dart:async';

import 'package:dartz/dartz_streaming.dart';
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
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
        home: TestSoccet(),
        theme: AppTheme.light,
        navigatorKey: navigatorKey,
        routes: routes,
      )
    );
  }
}
class StreamSocket{
  final _socketResponse= StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose(){
    _socketResponse.close();
  }
}

class TestSoccet extends StatefulWidget {
  @override
  _TestSoccetState createState() => _TestSoccetState();
}

class _TestSoccetState extends State<TestSoccet> {

StreamSocket streamSocket = StreamSocket();

void connectAndListen(){
  IO.Socket socket = IO.io('https://aio-test-vps.kulenkov-group.kz',
      IO.OptionBuilder()
       .setTransports(['websocket']).build());

    socket.onConnect((_) {
     print('connect');
    });

     socket.on('message.edit.167', (data) {
       print('some shit happened');
       print(data);
    });

    socket.on('event', (data) => streamSocket.addResponse);
    socket.onDisconnect((_) => print('disconnect'));

}

 @override
  void initState() {
    super.initState();
    connectAndListen();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      
    );
  }
}
