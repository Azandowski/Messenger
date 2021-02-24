import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/modules/create_category/presentation/pages/create_category_screen.dart';
import '../bloc/cubit/chats_cubit_cubit.dart';
import '../widgets/category_items.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ChatsCubit>();
    return Scaffold(
        appBar: AppBar(
          title: Text("Главная"),
        ),
        body: BlocConsumer<ChatsCubit, ChatsCubitState>(
          listener: (context, state) {
            if (state is ChatsCubitError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage,
                      style: TextStyle(color: Colors.red)),
                ), // SnackBar
              );
            }
            if (state is ChatsCubitNormal) {
              var stateCategory = state.chatCategoriesState;
              if (stateCategory is ChatCategoriesLoaded) {
                _index = stateCategory.index;
              }
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                if (!cubit.showCategoriesSpinner)
                  CategoriesSection(
                    categories: cubit.categories,
                    currentSelectedItemId: _index,
                    onNextClick: () {
                      Navigator.pushNamed(context, CreateCategoryScreen.id);
                    },
                  )
                else
                  Center(child: CircularProgressIndicator())
              ],
            );
          },
        ));
  }
}
