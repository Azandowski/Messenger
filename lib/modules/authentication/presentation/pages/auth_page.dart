import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/authentication/presentation/bloc/index.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<AuthenticationBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthenticationBloc>(),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Unauthenticated) {
            return TypeNumberStateScreen();
          } else if (state is Loading) {
            return LoadingWidget();
          } else if (state is PreSendCode) {
            return TypeCodeScreen();
          }
        },
      ),
    );
  }
}

class TypeNumberStateScreen extends StatefulWidget {
  @override
  _TypeNumberStateScreenState createState() => _TypeNumberStateScreenState();
}

class _TypeNumberStateScreenState extends State<TypeNumberStateScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
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
