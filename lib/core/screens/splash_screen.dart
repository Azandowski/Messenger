import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/authorization/bloc/auth_bloc.dart';
import 'package:messenger_mobile/main.dart';
import 'package:messenger_mobile/modules/edit_profile/presentation/pages/edit_profile_page.dart';
import '../../modules/authentication/presentation/pages/auth_page.dart';
import '../../modules/profile/presentation/pages/profile_page.dart';
import '../../locator.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // MARK: - Pages

  final bucket = PageStorageBucket();
  final pages = [
    ProfilePage(),
    ProfilePage(),
    SplashPage(),
    ProfilePage(),
  ];

  int _viewIndex = 0;

  NavigatorState get _navigator => navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
        create: (context) => sl<AuthBloc>(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushNamedAndRemoveUntil(
                    EditProfilePage.pageID, (route) => false);
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushNamedAndRemoveUntil(
                    LoginPage.id, (route) => false);
                break;
              default:
                break;
            }
          },
          child: Scaffold(
            //TODO PUT SOME IMAGE
            backgroundColor: Colors.black,
          ),
        ));
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
// BlocBuilder<AuthBloc, AuthState>(
//         builder: (context, state) {
//           if (state is Unauthenticated) {
//             return LoginPage();
//           } else if (state is Authenticated) {
//             return Scaffold(
//               backgroundColor: Colors.white,
//               extendBody: true,
//               body: PageStorage(
//                 bucket: bucket,
//                 child: IndexedStack(
//                   children: pages,
//                   index: _viewIndex
//                 )
//               ),
//               bottomNavigationBar: AppBottomBar(
//                 currentIndex: _viewIndex,
//                 onTap: (int index) {
//                   setState(() {
//                     _viewIndex = index;
//                   });
//                 }
//               ),
//               floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//               floatingActionButton: AddButton(),
//             );
//           } else {
//             return SplashPage();
//           }
//         },
//       ),
