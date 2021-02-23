import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/modules/authentication/presentation/pages/type_code_page.dart/pages/type_code_page.dart';
import 'package:messenger_mobile/modules/authentication/presentation/pages/type_phone_page/cubit/typephone_cubit.dart';
import 'package:messenger_mobile/modules/authentication/presentation/pages/type_phone_page/pages/type_phone_page.dart';
import '../../../../locator.dart';
import '../bloc/index.dart';

class LoginPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

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

  buildBody(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthenticationBloc>()),
        BlocProvider(create: (context) => TypephoneCubit(createCode: sl())),
      ],
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is InitialStat) {
            return TypePhonePage();
          } else if (state is CodeState) {
            return TypeCodePage(
              codeEntity: state.codeEntity,
            );
          }
        },
      ),
    );
  }
}
