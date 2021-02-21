import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/authentication/presentation/bloc/index.dart';
import 'package:messenger_mobile/modules/authentication/presentation/pages/auth_page.dart';
import 'package:messenger_mobile/modules/profile/presentation/pages/profile_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthenticationBloc _authenticationBloc;
  @override
  void initState() {
    _authenticationBloc = sl<AuthenticationBloc>();
    _authenticationBloc.add(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          print('shit damn');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else if (state is Authenticated) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProfilePage()));
        }
      },
      child: Scaffold(
        body: Center(
          child: Text('Splash Screen'),
        ),
      ),
    );
  }
}
