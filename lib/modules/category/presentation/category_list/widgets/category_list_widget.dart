import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/category/presentation/category_list/widgets/category_cell.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';

class CategoriesList extends StatelessWidget {
  final List<CategoryEntity> items;
  final CategoryCellType cellType;
  final Function(CategoryCellActionType, CategoryEntity) onSelectedOption;
  final Function(CategoryEntity) onSelect;

  CategoriesList({
    @required this.items,
    @required this.cellType,
    this.onSelectedOption,
    this.onSelect,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ReorderableListView(
        header: Container(
          key: ValueKey('header'),
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Категории: ${items.length}',
            textAlign: TextAlign.center,
          )
        ),
        onReorder: (oldI, newI){
          
        },
        children: [
          for (final item in items)
            GestureDetector(
              key: ValueKey(item),
              onTap: () {
                if (onSelect != null) {
                  onSelect(item);
                }
              },
              child: CategoryCell(
                item: item,
                cellType: cellType,
                onSelectedOption: onSelectedOption,
              ),
            )
        ],
      )
    );
  }
}