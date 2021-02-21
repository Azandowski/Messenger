import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../locator.dart';
import '../../modules/authentication/presentation/bloc/index.dart';
import '../../modules/authentication/presentation/pages/auth_page.dart';
import '../../modules/profile/presentation/pages/profile_page.dart';

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
    return BlocProvider<AuthenticationBloc>(
      create: (context) => _authenticationBloc,
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Unauthenticated) {
            return LoginPage();
          } else if (state is Authenticated) {
            return ProfilePage();
          } else {
            return SplashPage();
          }
        },
      ),
    );
  }
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO put here splash image of AIO Messenger
      body: Center(
        child: Text('initing'),
      ),
    );
  }
}
