import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger_mobile/modules/unavailable_screens/presentation/unavailable_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/application.dart';
import '../../locator.dart';
import '../../modules/authentication/domain/repositories/authentication_repository.dart';
import '../../modules/chats/presentation/pages/chats_screen.dart';
import '../../modules/creation_module/presentation/pages/creation_module_screen.dart';
import '../../modules/profile/presentation/pages/profile_page.dart';
import '../widgets/independent/bottomBar/appBottomBar.dart';
import 'splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  void initState() {
    super.initState();
    _askPermissions();
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus != PermissionStatus.granted) {
      _handleInvalidPermissions(permissionStatus);
    } else {
      sl<AuthenticationRepository>().sendContacts();
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.request();
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.contacts].request();
      return statuses[Permission.contacts] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to contacts data denied",
          details: null);
    } else {
      throw PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Contacts are not available on device",
          details: null);
    }
  }

  final bucket = PageStorageBucket();

  NavigatorState get _navigator => sl<Application>().navKey.currentState;

  get pages => [
    ChatsScreen(),
    UnavailableScreen('smart_bot'.tr()),
    UnavailableScreen('calls'.tr()),
    ProfilePage(),
  ];

  int _viewIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      floatingActionButton: AddButton(
        onTap: () {
          _navigator.push(CreationModuleScreen.route());
        },
      ),
    );
  }
}
