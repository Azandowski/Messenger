import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../app/appTheme.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_action_button.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_params.dart';
import '../../../../../core/widgets/independent/dialogs/dialogs.dart';
import '../../../../../core/widgets/independent/images/ImageWithCorner.dart';
import '../../../../chats/domain/entities/category.dart';

class CategoryCell extends StatelessWidget {
  const CategoryCell({
    Key key,
    @required this.item,
    @required this.cellType,
    @required this.onSelectedOption,
  }) : super(key: key);

  final CategoryEntity item;
  final CategoryCellType cellType;
  final Function(CategoryCellActionType p1, CategoryEntity p2) onSelectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
        leading: FittedBox(
          fit: BoxFit.scaleDown,
          child: AvatarImage(
            isFromAsset: false,
            path: item.avatar,
            width: 60, height: 60,
          )
        ),
        title: Text(
          item.name, 
          style: AppFontStyles.headerMediumStyle,
        ),
      trailing: cellType == CategoryCellType.withOptions ? 
        menuIcon(context) : SizedBox(),
      ),
    );
  }


  Widget menuIcon (BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_horiz, color: Colors.black),
      onPressed: () {
        _showOptionsDialog(context);
      },
    );
  }


  void _showOptionsDialog (BuildContext context) {
    showDialog(context: context, builder: (_) => DialogsView(
      dialogViewType: DialogViewType.actionSheet,
      actionButton: [
        CategoryCellActionType.edit, CategoryCellActionType.delete
      ].map((e) => DialogActionButton(
        buttonStyle: e != CategoryCellActionType.delete ? 
          DialogActionButtonStyle.black : DialogActionButtonStyle.dangerous,
        title: e.title,
        onPress: () {
          onSelectedOption(e, item);
        }
      )).toList()
    ));
  }
}

// * * Типы cell
enum CategoryCellType {
  empty, withOptions
}


// * * Список возможных actions с cell
enum CategoryCellActionType {
  // * * Нужен чтобы удалить чат из списка
  delete, 
  // * * Нужен чтобы переместить чат в другую категорию
  edit
}


extension ChatItemActionUIExtension on CategoryCellActionType {
  String get title {
    switch (this) {
      case CategoryCellActionType.delete:
        return 'delete_category'.tr();
      case CategoryCellActionType.edit:
        return 'edit'.tr();
      default:
        return null;
    }
  }
}