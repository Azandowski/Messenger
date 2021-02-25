import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../modules/authentication/presentation/pages/auth_page.dart';
import '../../modules/authentication/presentation/pages/type_name_page/pages/type_name_page.dart';
import '../authorization/bloc/auth_bloc.dart';
import 'app_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      if (state is Unknown) {
        return SplashPage();
      } else if (state is Unauthenticated) {
        return LoginPage();
      } else if (state is Authenticated) {
        return AppScreen();
      } else if (state is NeedsNamePhoto) {
        return TypeNamePage(
          user: state.user,
        );
      } else { return Container(); }
    },
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
