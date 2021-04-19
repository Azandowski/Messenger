import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/snackbar_util.dart';
import '../../../../app/application.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../app/appTheme.dart';
import '../../../../core/blocs/category/bloc/category_bloc.dart';
import '../../../../core/widgets/independent/buttons/bottom_action_button.dart';
import '../../../../core/widgets/independent/dialogs/dialog_action_button.dart';
import '../../../../core/widgets/independent/dialogs/dialog_params.dart';
import '../../../../core/widgets/independent/dialogs/dialogs.dart';
import '../../../../core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import '../../../../locator.dart';
import '../../../chats/domain/entities/category.dart';
import '../../domain/entities/create_category_screen_params.dart';
import '../create_category_main/pages/create_category_screen.dart';
import 'widgets/category_cell.dart';
import 'widgets/category_list_widget.dart';

class CategoryList extends StatefulWidget {

  static var id = 'categorylist';

  static Route route({ isMoveChat = false, isReorderingEnabled = true  }) {
    return MaterialPageRoute<void>(builder: (_) => CategoryList(
      isMoveChat: isMoveChat,
      isReorderingEnabled: isReorderingEnabled
    ));
  }

  final bool isMoveChat;
  final bool isReorderingEnabled;

  CategoryList({
    this.isMoveChat = false,
    this.isReorderingEnabled = true
  });

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  NavigatorState get _navigator => sl<Application>().navKey.currentState;

  List<CategoryEntity> reorderedCategories = [];
  bool _didReorderItems = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isMoveChat ? 'move_chat'.tr() : 'chat_categories'.tr()
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
      body: SafeArea(
        child: BlocConsumer<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state is CategoriesUpdating) {
              SnackUtil.showLoading(context: context);
            } else if (state is CategoriesErrorHappened) {
              SnackUtil.showError(context: context, message: state.message);
            } else if (state is CategoryLoaded) {
              updateReorderedCategories(state);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            } else {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                        widget.isMoveChat ? 'select_category_to_move'.tr() :
                          "category_screen_hint".tr(),
                        style: AppFontStyles.placeholderStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 15,),
                    returnStateWidget(state, context),
                    if (_didReorderItems)
                      SizedBox(height: 80)
                  ],
                ),
                if (_didReorderItems)
                  BottomActionButtonContainer(
                    title: 'save'.tr(),
                    onTap: () { 
                      var updates = this.getCategoriesDifferences(
                        oldIDS: state.categoryList.map((e) => e.id).toList(), 
                        newIDS: reorderedCategories.map((e) => e.id).toList()
                      );

                      context.read<CategoryBloc>().add(CategoriesReordered(
                        categoryUpdated: updates
                      ));
                    }
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  void updateReorderedCategories (CategoryState categoryState) {
    var categories = (categoryState.categoryList ?? []) as List<CategoryEntity>;
    reorderedCategories = categories.map((e) => e.clone()).toList();

    if (widget.isMoveChat) {
      reorderedCategories = reorderedCategories.where((e) => !e.isSystemGroup).toList();
    }
  }

  /// Body of Categories List
  Widget returnStateWidget(state, context) {
    if (reorderedCategories.length == 0) {
      updateReorderedCategories(state);
    }

    if (state is CategoryEmpty) {
      return Expanded(
        child: ListView.builder(
          itemBuilder: (context, int index) {
            return CellShimmerItem();
          },
          itemCount: 10,
        )
      );
    } else return CategoriesList(
        reorderingEnabled: widget.isReorderingEnabled,
        items: reorderedCategories,
        cellType: widget.isMoveChat ? 
          CategoryCellType.empty : CategoryCellType.withOptions,
        onSelectedOption: (CategoryCellActionType action, CategoryEntity entity) {
          if (action == CategoryCellActionType.delete) {
            showDialog(context: context,builder: (_){
              return DialogsView( 
                title: 'remove_chat_from_category'.tr(),
                description: 'remove_chat_from_category_hint'.tr(),
                actionButton: [
                  DialogActionButton(
                    title: 'cancel'.tr(), 
                    buttonStyle: DialogActionButtonStyle.cancel,
                    onPress: () {
                      Navigator.pop(context);
                    }
                  ),
                  DialogActionButton(
                    title: 'delete'.tr(), 
                    buttonStyle: DialogActionButtonStyle.dangerous,
                    onPress: () {
                      Navigator.pop(context);
                      BlocProvider.of<CategoryBloc>(context).add(CategoryRemoving(categoryId: entity.id));                    
                    }
                  ),
               ]
              );
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
  }
  // BottomBar
}


extension on _CategoryListState {
  /// Returns Map of updated categories for the Backend
  /// Example: { orders[2]: 0 }
  /// So [orders[id]]'s value is a current order
  /// ! Order starts from 1 not zero
  Map<String, int> getCategoriesDifferences ({
    @required List oldIDS, 
    @required List newIDS
  }) {
    print(oldIDS);
    print(newIDS);
    List arr2 = newIDS;
    Map<String, int> differences = {};

    newIDS.asMap().forEach((index, item) {
      differences['$item'] = index  + 1;
    });

    // oldIDS.asMap().forEach((index, item) {
    //   if (item != arr2[index]) {
    //     var temp = arr2[index];
    //     // arr2.removeAt(index);        
    //     var oldIndex = oldIDS.indexOf(temp);
    //     arr2.insert(oldIndex, temp);
    //     // arr2[index] = item;
    //     // arr2[arr2.lastIndexOf(item)] = temp;
    //     differences['$temp'] = index + 1;
    //   }
    // });
    
    return differences;
  }
}

