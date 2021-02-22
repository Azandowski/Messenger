import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/authentication/presentation/pages/auth_page.dart';
import '../../modules/edit_profile/presentation/pages/edit_profile_page.dart';

Map<String, WidgetBuilder> routes = {
  EditProfilePage.pageID: (context) => EditProfilePage(),
  LoginPage.id: (context) => LoginPage(),
};
