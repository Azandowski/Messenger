import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/create_category/presentation/chooseChats/presentation/chat_choose_page.dart';

class CreateCategoryScreen extends StatelessWidget {
  static final String id = 'create_category';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создать категорию'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, ChooseChatsPage.id);
      },),
    );
  }
}