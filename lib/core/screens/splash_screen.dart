import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/blocs/bloc/auth_bloc.dart';
import 'package:messenger_mobile/core/widgets/independent/bottomBar/appBottomBar.dart';
import 'package:messenger_mobile/modules/authentication/presentation/pages/auth_page.dart';
import 'package:messenger_mobile/modules/chats/presentation/pages/chats_screen.dart';
import 'package:messenger_mobile/modules/profile/presentation/pages/profile_page.dart';
import '../../locator.dart';


class SplashScreen extends StatefulWidget {
  
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // MARK: - Pages

  final bucket = PageStorageBucket();
  final pages = [
    ChatsScreen(),
    ProfilePage(),
    SplashPage(),
    ProfilePage(),
  ];

  int _viewIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => sl<AuthBloc>()..add(AppStarted()),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Unauthenticated) {
            return LoginPage();
          } else if (state is Authenticated) {
            return Scaffold(
              backgroundColor: Colors.white,
              extendBody: true,
              body: PageStorage(
                bucket: bucket,
                child: IndexedStack(
                  children: pages,
                  index: _viewIndex
                )
              ),
              bottomNavigationBar: AppBottomBar(
                currentIndex: _viewIndex, 
                onTap: (int index) {
                  setState(() {
                    _viewIndex = index;
                  });
                }
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              floatingActionButton: AddButton(),
            );
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
