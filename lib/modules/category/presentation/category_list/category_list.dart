import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/blocs/category/bloc/category_bloc.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/bottom_action_button.dart';
import 'package:messenger_mobile/core/widgets/independent/dialogs/dialog_action_button.dart';
import 'package:messenger_mobile/core/widgets/independent/dialogs/dialog_params.dart';
import 'package:messenger_mobile/core/widgets/independent/dialogs/dialogs.dart';
import 'package:messenger_mobile/modules/category/domain/entities/create_category_screen_params.dart';
import 'package:messenger_mobile/modules/category/presentation/category_list/widgets/category_cell.dart';
import 'package:messenger_mobile/modules/category/presentation/category_list/widgets/category_list_widget.dart';
import 'package:messenger_mobile/modules/category/presentation/create_category_main/pages/create_category_screen.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import 'package:messenger_mobile/modules/chats/data/model/category_model.dart';
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

  List<CategoryEntity> reorderedCategories = [];
  bool _didReorderItems = false;

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
          if (state is CategoriesUpdating) {
            Scaffold.of(context).showSnackBar(SnackBar(content: LinearProgressIndicator(), duration: Duration(days: 2),));
          } else if (state is CategoriesErrorHappened) {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is CategoryLoaded){
            Scaffold.of(context).hideCurrentSnackBar();
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    color: Colors.white,
                    child: Text(
                      widget.isMoveChat ? 'Выберите категорию для переноса' :
                        'Вы можете создавать свои категории с нужными чатами, для быстрого переключения между ними.',
                      style: AppFontStyles.placeholderStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 15,),
                  returnStateWidget(state, context),
                ],
              ),
              if (_didReorderItems)
                BottomActionButtonContainer(
                  title: 'Сохранить',
                  isLoading: state is CategoriesUpdating,
                  onTap: () { 
                    context.read<CategoryBloc>().add(CategoriesReordered(
                      categoryUpdated: this.getCategoriesDifferences(
                        oldCategories: state.categoryList, 
                        newCategories: reorderedCategories
                      )
                    ));
                  }
                )
            ],
          );
        },
      ),
    );
  }


  /// Body of Categories List
  Widget returnStateWidget(state, context) {
    if (reorderedCategories.length == 0) {
      if ((state is CategoryLoaded || state is CategoriesUpdating)) {
        var categories = (state.categoryList ?? []) as List<CategoryEntity>;
        reorderedCategories = categories.map((e) => e.clone()).toList();
      }
    }

    if (state is CategoryLoaded || state is CategoriesUpdating) {
      return CategoriesList(
        items: reorderedCategories,
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
        onReorderCategories: (oldIndex, newIndex) {
          var tempItem = reorderedCategories[oldIndex];
          _didReorderItems = true;

          setState(() {
            reorderedCategories.insert(newIndex, tempItem);
            var oldUpdatedIndex = newIndex > oldIndex ? oldIndex : oldIndex + 1;
            reorderedCategories.removeAt(oldUpdatedIndex);
          });
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

  // BottomBar
}


extension on _CategoryListState {
  /// Returns Map of updated categories
  /// Example: { categoryID: 4, categoryID2: 3 }
  Map<int, int> getCategoriesDifferences ({
    @required List<CategoryEntity> oldCategories, 
    @required List<CategoryEntity> newCategories
  }) {
    List<CategoryEntity> arr2 = newCategories.map((e) => e.clone()).toList();
    Map<int, int> differences = {};
    
    oldCategories.asMap().forEach((index, item) {
      if (item.id != arr2[index].id) {
         
        var temp = arr2[index].clone();
         
        arr2[index] = item.clone();
        arr2[arr2.lastIndexWhere((e) => e.id == item.id)] = temp;
        print('index::: $index');
        print( arr2.lastIndexWhere((e) => e.id == item.id));
        if (differences[temp.id] == null) {
          differences[temp.id] = index;
        }
      }
    });
    
    return differences;
  }
}

