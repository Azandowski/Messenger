import 'package:flutter/material.dart';

import '../../modules/category/presentation/category_list/category_list.dart';
import '../../modules/category/presentation/create_category_main/pages/create_category_screen.dart';
import '../../modules/groupChat/presentation/create_group/create_group_page.dart';
import '../../modules/groupChat/presentation/create_group/create_group_screen.dart';


Map<String, WidgetBuilder> routes = {
  CreateCategoryScreen.id: (_) => CreateCategoryScreen(),
  CategoryList.id: (_) => CategoryList(),
  CreateGroupScreen.id: (_) => CreateGroupScreen(),
  CreateGroupPage.id: (_) => CreateGroupPage(),
};
