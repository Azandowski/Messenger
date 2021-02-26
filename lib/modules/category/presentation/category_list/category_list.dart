import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/blocs/category/bloc/category_bloc.dart';
import 'package:messenger_mobile/modules/category/presentation/category_list/widgets/category_cell.dart';
import 'package:messenger_mobile/modules/category/presentation/category_list/widgets/category_list_widget.dart';
import 'package:messenger_mobile/modules/category/presentation/create_category_main/pages/create_category_screen.dart';
import 'package:messenger_mobile/modules/category/presentation/create_category_main/widgets/chat_skeleton_item.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';

class CategoryList extends StatelessWidget {

  static var id = 'categorylist';

  final bool isMoveChat;

  CategoryList({this.isMoveChat = false});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text( isMoveChat ? 'Переместить чат' : 'Категории чатов'),
            actions: [
              IconButton(
               icon: Icon(Icons.add,
            ),
              onPressed: () {
                Navigator.pushNamed(context, CreateCategoryScreen.id);
              },
            )],
          ),
          backgroundColor: AppColors.pinkBackgroundColor,
          body: Column(
                children: [
                 Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                      color: Colors.white,
                      child: Text(isMoveChat ? 'Выберите категорию для переноса' :
                        'Вы можете создавать свои категории с нужными чатами, для быстрого переключения между ними.',
                        style: AppFontStyles.greyPhoneStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 15,),
                  returnStateWidget(state, context),
                ],
              ),
       );
     }
    );
  }

  Widget returnStateWidget(state, context){
    if (state is CategoryLoaded) {
      return CategoriesList(
        items: state.categoryList,
        cellType: CategoryCellType.withOptions,
        onSelectedOption: (CategoryCellActionType action, CategoryEntity entity) {
          if (action == CategoryCellActionType.delete) {
             // TODO: Implement delete category
          } else {
             // TODO: Implement edit chat
          }
        },
      );
    } else if (state is CategoryEmpty) {
      return Expanded(
        child: ListView.builder(
          itemBuilder: (context, int index) {
            return ChatShimmerItem();
          },
          itemCount: 10,
        )
      );
    } else {
      return Text('default');
    }
  }
}

