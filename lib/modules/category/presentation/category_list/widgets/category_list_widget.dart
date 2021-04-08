import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/image_text_view.dart';
import '../../../../chats/domain/entities/category.dart';
import 'category_cell.dart';

class CategoriesList extends StatelessWidget {
  final List<CategoryEntity> items;
  final CategoryCellType cellType;
  final Function(CategoryCellActionType, CategoryEntity) onSelectedOption;
  final Function(CategoryEntity) onSelect;
  final Function(int, int) onReorderCategories;
  final bool reorderingEnabled;

  CategoriesList({
    @required this.items,
    @required this.cellType,
    this.onSelectedOption,
    this.onSelect,
    this.onReorderCategories,
    this.reorderingEnabled = true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> elements = [
      for (final item in items)
        InkWell(
          key: ValueKey(item.id),
          onTap: () {
            if (onSelect != null) {
              onSelect(item);
            }
          },
          child: CategoryCell(
            item: item,
            cellType: item.isSystemGroup ? CategoryCellType.empty : cellType,
            onSelectedOption: onSelectedOption,
          ),
        )
    ];
    
    if (elements.length == 0)
      return Center(
        child: EmptyView(
          text: 'nothing_found'.tr()
        ),
      );

    return Expanded(
      child: reorderingEnabled ? ReorderableListView(
        header: Container(
          key: ValueKey('header'),
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'category_count'.tr(
              namedArgs: {
                'count': '${items.length}'
              }
            ),
            textAlign: TextAlign.center,
          )
        ),
        onReorder: (oldI, newI) {
          if (onReorderCategories != null) {
            onReorderCategories(oldI, newI);
          }
        },
        children: elements,
      ) : ListView(
        children: elements,
      )
    );
  }
}