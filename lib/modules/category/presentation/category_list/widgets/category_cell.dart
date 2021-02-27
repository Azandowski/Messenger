import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';

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
        child: CircleAvatar(
              backgroundImage: NetworkImage(item.avatar),
              minRadius: 30,
            ),
          ),
      title: Text(
        item.name, 
        style: AppFontStyles.headerMediumStyle,
      ),
      subtitle:
        Text(
          (item.totalChats ?? 0).toString(),
          style: AppFontStyles.mediumStyle,
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
          }
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