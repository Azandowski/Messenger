import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import '../../modules/authentication/presentation/pages/auth_page.dart';
import '../../modules/authentication/presentation/pages/type_name_page/pages/type_name_page.dart';
import '../blocs/authorization/bloc/auth_bloc.dart';
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
        return  AppScreen();
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
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      body:Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          gradient: AppGradinets.mainButtonGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/aiochat.png',width: w/2,),
            SizedBox(height: 15,),
            Text('AIO Messenger',style: AppFontStyles.logoHeadingStyle)
          ],
        ),
      )
    );
  }
}
