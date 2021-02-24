import 'package:flutter/material.dart';

import '../../../../app/appTheme.dart';
import '../../domain/entities/category.dart';
import 'category_item.dart';

class CategoriesSection extends StatelessWidget {
  final List<CategoryEntity> categories;
  final int currentSelectedItemId;

  const CategoriesSection(
      {@required this.categories,
      @required this.currentSelectedItemId,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
      color: Theme.of(context).primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Категории чатов', style: AppFontStyles.headingTextSyle),
            Icon(Icons.chevron_right)
          ]),
          SizedBox(
            height: 15,
          ),
          CategoryItemsScroll(
            categories: categories,
            currentSelectedItemId: currentSelectedItemId,
          )
        ],
      ),
    );
  }
}

class CategoryItemsScroll extends StatelessWidget {
  final List<CategoryEntity> categories;
  final int currentSelectedItemId;

  const CategoryItemsScroll({
    @required this.categories,
    @required this.currentSelectedItemId,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories
              .map((e) => Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: CategoryItem(
                        entity: e, isSelected: currentSelectedItemId == e.id),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
