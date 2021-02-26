import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/blocs/category/bloc/category_bloc.dart';
import 'package:messenger_mobile/modules/category/presentation/create_category_main/pages/create_category_screen.dart';
import '../bloc/cubit/chats_cubit_cubit.dart';
import '../widgets/category_items.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {

  @override
  void initState() {
    var cubit = context.read<ChatsCubit>();
    cubit.loadAllChats();
    super.initState();
  }

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
        },
        builder: (context, state) {      
          return Column(
            children: [
              BlocConsumer<CategoryBloc, CategoryState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, categoryState) {
                  return CategoriesSection(
                    isLoading: categoryState is CategoryEmpty,
                    categories: categoryState is CategoryLoaded ? categoryState.categoryList : [],
                    currentSelectedItemId: state.currentTabIndex, 
                    onNextClick: () {
                      Navigator.pushNamed(context, CreateCategoryScreen.id);
                    },
                    onItemSelect: (int id) {
                      cubit.tabUpdate(id);
                    },
                  );
                },
              ),
            ],
          );
        },
      )
    );
  }
}
