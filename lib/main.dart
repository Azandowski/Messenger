import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'locator.dart' as serviceLocator;

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async { 
  await serviceLocator.init();

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setEnabledSystemUIOverlays([]);

  // TODO: Put here BLOC
  runApp(Container());
}

class MainApp extends StatelessWidget { 
  
  @override
  Widget build(BuildContext context) { 
    
    return MaterialApp(
      // TODO: Put here Splash screen
      home: Container(),
      navigatorKey: navigatorKey
    );
  }
}