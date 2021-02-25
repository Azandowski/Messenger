import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../locator.dart';
import '../../modules/chats/presentation/bloc/cubit/chats_cubit_cubit.dart';
import '../../modules/chats/presentation/pages/chats_screen.dart';
import '../../modules/profile/presentation/pages/profile_page.dart';
import '../widgets/independent/bottomBar/appBottomBar.dart';
import 'splash_screen.dart';

class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
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
    return MultiBlocProvider(
      providers: [
              BlocProvider.value(value: sl<ChatsCubit>()),
      ],
          child: Scaffold(
            backgroundColor: Colors.white,
            extendBody: true,
            body: PageStorage(
                bucket: bucket,
                child: IndexedStack(children: pages, index: _viewIndex)),
            bottomNavigationBar: AppBottomBar(
                currentIndex: _viewIndex,
                onTap: (int index) {
                  setState(() {
                    _viewIndex = index;
                  });
                }),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: AddButton(),
          ),
    );
  }
}
