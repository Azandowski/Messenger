import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/index.dart';
import 'phone_enter_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
              child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: buildBody(context),
      ))),
    );
  }

  BlocBuilder<AuthenticationBloc, AuthenticationState> buildBody( BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Unauthenticated) {
          return PhoneEnterPage();
        } else if (state is Loading) {
          return LoadingWidget();
        } else if (state is PreSendCode) {
          return TypeCodeScreen();
        }
      },
    );
  }
}

class TypeCodeScreen extends StatefulWidget {
  @override
  _TypeCodeScreenState createState() => _TypeCodeScreenState();
}

class _TypeCodeScreenState extends State<TypeCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.pink,
      ),
    );
  }
}
