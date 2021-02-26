import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/category/presentation/category_list/category_list.dart';
import 'package:messenger_mobile/modules/category/presentation/create_category_main/pages/create_category_screen.dart';


Map<String, WidgetBuilder> routes = {
  CreateCategoryScreen.id: (_) => CreateCategoryScreen(),
  CategoryList.id: (_) => CategoryList(),
};
