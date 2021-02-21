import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/blocs/bloc/auth_bloc.dart';
import 'package:messenger_mobile/modules/authentication/presentation/pages/auth_page.dart';
import 'package:messenger_mobile/modules/profile/presentation/pages/profile_page.dart';
import '../../locator.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthBloc _authenticationBloc;
  @override
  void initState() {
    _authenticationBloc = sl<AuthBloc>();
    _authenticationBloc.add(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => _authenticationBloc,
      child: BlocBuilder<AuthBloc, AuthState>(
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
