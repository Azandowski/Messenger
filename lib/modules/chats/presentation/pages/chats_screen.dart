import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../locator.dart';
import '../bloc/cubit/chats_cubit_cubit.dart';
import '../widgets/category_items.dart';

class ChatsScreen extends StatefulWidget {

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  
  ChatsCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = sl<ChatsCubit>();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Главная"),
        ),
        body: BlocConsumer<ChatsCubit, ChatsCubitState>(
          cubit: cubit..initCubit(),
          listener: (context, state) {
            if (state is ChatsCubitError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage,
                      style: TextStyle(color: Colors.red)),
                ), // SnackBar
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                if (!cubit.showCategoriesSpinner)
                  CategoriesSection(
                    categories: cubit.categories,
                    currentSelectedItemId: 2,
                  )
                else
                  Center(child: CircularProgressIndicator())
              ],
            );
          },
        ));
  }
}
