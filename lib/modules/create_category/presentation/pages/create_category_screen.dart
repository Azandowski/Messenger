import 'package:flutter/material.dart';

class CreateCategoryScreen extends StatelessWidget {
  static final String id = 'create_category';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создать категорию'),
      ),
    );
  }
}