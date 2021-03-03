import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/blocs/category/bloc/category_bloc.dart';
import 'package:messenger_mobile/core/widgets/independent/dialogs/dialog_action_button.dart';
import 'package:messenger_mobile/core/widgets/independent/dialogs/dialog_params.dart';
import 'package:messenger_mobile/core/widgets/independent/dialogs/dialogs.dart';
import 'package:messenger_mobile/modules/category/domain/entities/create_category_screen_params.dart';
import 'package:messenger_mobile/modules/category/presentation/category_list/widgets/category_cell.dart';
import 'package:messenger_mobile/modules/category/presentation/category_list/widgets/category_list_widget.dart';
import 'package:messenger_mobile/modules/category/presentation/create_category_main/pages/create_category_screen.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';

import '../../../../main.dart';

class CategoryList extends StatefulWidget {

  static var id = 'categorylist';

  static Route route({ isMoveChat = false }) {
    return MaterialPageRoute<void>(builder: (_) => CategoryList(isMoveChat: isMoveChat,));
  }

  final bool isMoveChat;

  CategoryList({
    this.isMoveChat = false
  });

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  NavigatorState get _navigator => navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.isMoveChat ? 'Переместить чат' : 'Категории чатов'
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add,),
                onPressed: () {
                  Navigator.pushNamed(context, CreateCategoryScreen.id);
                },
              )
            ],
          ),
          backgroundColor: AppColors.pinkBackgroundColor,
          body: BlocConsumer<CategoryBloc, CategoryState>(
            listener: (context, state) {
             if(state is CategoriesUpdating){
               Scaffold.of(context).showSnackBar(SnackBar(content: LinearProgressIndicator(),duration:Duration(days: 2),));
             }else if(state is CategoriesErrorHappened){
               Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.message)));
             }
             if(state is CategoryLoaded){
               Scaffold.of(context).hideCurrentSnackBar();
             }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  color: Colors.white,
                  child: Text(widget.isMoveChat ? 'Выберите категорию для переноса' :
                      'Вы можете создавать свои категории с нужными чатами, для быстрого переключения между ними.',
                            style: AppFontStyles.placeholderStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 15,),
                        returnStateWidget(state, context),
                      ],
               );
            },
          ),
       );
  }

  Widget returnStateWidget(state, context) {
    if (state is CategoryLoaded || state is CategoriesUpdating) {
      return CategoriesList(
        items: state.categoryList,
        cellType: widget.isMoveChat ? CategoryCellType.empty : CategoryCellType.withOptions,
        onSelectedOption: (CategoryCellActionType action, CategoryEntity entity) {
          if (action == CategoryCellActionType.delete) {
           showDialog(context: context,builder: (_){
             return DialogsView( 
                title: 'Убрать чат из категории?',
                description: 'Чаты внутри категории не будут удалены.',
                actionButton: [
                  DialogActionButton(
                  title: 'Отмена', 
                  buttonStyle: DialogActionButtonStyle.cancel,
                  onPress: () {
                    Navigator.pop(context);
                  }),
                 DialogActionButton(
                  title: 'Удалить', 
                  buttonStyle: DialogActionButtonStyle.dangerous,
                  onPress: () {
                    Navigator.pop(context);
                    BlocProvider.of<CategoryBloc>(context).add(CategoryRemoving(categoryId: entity.id));                    
                  }),
               ],);
           }); 
          } else {
            _navigator.push(CreateCategoryScreen.route(
              mode: CreateCategoryScreenMode.edit,
              category: entity
            ));
          }
        },
        onSelect: (item) {
          Navigator.of(context).pop(item);
        },
      );
    } else if (state is CategoryEmpty) {
      return Expanded(
        child: ListView.builder(
          itemBuilder: (context, int index) {
            return CellShimmerItem();
          },
          itemCount: 10,
        )
      );
    } else {
      return Text('default');
    }
  }
}

