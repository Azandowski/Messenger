import 'package:flutter/material.dart';

import '../../../../../app/appTheme.dart';
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
        PopupMenuButton<CategoryCellActionType>(
          itemBuilder: (context) => [
            CategoryCellActionType.edit, CategoryCellActionType.delete
          ].map((e) {
            return PopupMenuItem(
              value: e,
              child: Text(e.title)
            );
          }).toList(),
          onSelected: (CategoryCellActionType action) {
            onSelectedOption(action, item);
          },
          offset: Offset(0, 100),
        ) : SizedBox(),
      ),
    );
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
        return 'Удалить категорию';
      case CategoryCellActionType.edit:
        return 'Редактировать';
      default:
        return null;
    }
  }
}