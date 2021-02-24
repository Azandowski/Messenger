import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../locator.dart';
import '../../domain/entities/category.dart';
import '../bloc/cubit/chats_cubit_cubit.dart';
import '../widgets/category_items.dart';

class ChatsScreen extends StatelessWidget {
  final List<CategoryEntity> entities = [
    CategoryEntity(
        id: 1,
        name: 'Microphone',
        avatar:
            'https://imgresizer.eurosport.com/unsafe/1200x0/filters:format(jpeg):focal(1056x358:1058x356)/origin-imgresizer.eurosport.com/2021/02/19/2998019-61516108-2560-1440.jpg',
        totalChats: 2),
    CategoryEntity(
        id: 2,
        name: 'SuperWork',
        avatar:
            'https://imgresizer.eurosport.com/unsafe/1200x0/filters:format(jpeg):focal(1056x358:1058x356)/origin-imgresizer.eurosport.com/2021/02/19/2998019-61516108-2560-1440.jpg',
        totalChats: 2),
    CategoryEntity(
        id: 3,
        name: 'Tourism',
        avatar:
            'https://imgresizer.eurosport.com/unsafe/1200x0/filters:format(jpeg):focal(1056x358:1058x356)/origin-imgresizer.eurosport.com/2021/02/19/2998019-61516108-2560-1440.jpg',
        totalChats: 2),
    CategoryEntity(
        id: 4,
        name: 'MedApp',
        avatar:
            'https://imgresizer.eurosport.com/unsafe/1200x0/filters:format(jpeg):focal(1056x358:1058x356)/origin-imgresizer.eurosport.com/2021/02/19/2998019-61516108-2560-1440.jpg',
        totalChats: 2),
    CategoryEntity(
        id: 4,
        name: 'MedApp',
        avatar:
            'https://imgresizer.eurosport.com/unsafe/1200x0/filters:format(jpeg):focal(1056x358:1058x356)/origin-imgresizer.eurosport.com/2021/02/19/2998019-61516108-2560-1440.jpg',
        totalChats: 2)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Главная"),
        ),
        body: BlocConsumer<ChatsCubit, ChatsCubitState>(
          cubit: sl<ChatsCubit>()..initCubit(),
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
                if (state is ChatsCubitNormal &&
                    state.chatListsState != ChatListsLoading)
                  CategoriesSection(
                    categories: entities,
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
