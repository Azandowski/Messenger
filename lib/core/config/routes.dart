import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/create_category/presentation/chooseChats/presentation/chat_choose_page.dart';
import 'package:messenger_mobile/modules/create_category/presentation/create_category_main/pages/create_category_screen.dart';

Map<String, WidgetBuilder> routes = {
  CreateCategoryScreen.id: (_) => CreateCategoryScreen(),
  ChooseChatsPage.id: (_) => ChooseChatsPage(),
};
