import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../app/appTheme.dart';
import '../../domain/entities/category.dart';
import 'category_item.dart';
import 'category_shimmer_items.dart';

class CategoriesSection extends StatelessWidget {
  final List<CategoryEntity> categories;
  final int currentSelectedItemId;
  final Function onNextClick;
  final Function(int) onItemSelect;
  final bool isLoading;

  const CategoriesSection({
      @required this.categories,
      @required this.currentSelectedItemId,
      @required this.onNextClick,
      @required this.isLoading,
      @required this.onItemSelect,
      Key key
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
      color: Theme.of(context).primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'chat_categories'.tr(), 
              style: AppFontStyles.headerMediumStyle),
            InkWell(
              child: Icon(Icons.chevron_right),
              onTap: onNextClick,
            )
          ]),
          SizedBox(
            height: 15,
          ),
          if (isLoading)
            CategoryShimmerItems()
          else
            CategoryItemsScroll(
              categories: categories,
              currentSelectedItemId: currentSelectedItemId,
              onItemSelect: onItemSelect)
        ],
      ),
    );
  }
}

class CategoryItemsScroll extends StatelessWidget {
  final List<CategoryEntity> categories;
  final int currentSelectedItemId;
  final Function(int) onItemSelect;

  const CategoryItemsScroll({
    @required this.categories,
    @required this.currentSelectedItemId,
    @required this.onItemSelect,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            CategoryItem(
              isAvatarFromAssets: true,
              isSelected: currentSelectedItemId == 0,
              entity: CategoryEntity(
                id: 0, totalChats: 0,
                avatar: 'assets/images/logo.png',
                name: 'all'.tr(),
                noReadCount: 0,
                appChatID: 1
              ),
              onSelect: () {
                onItemSelect(0);
              }
            ),
            SizedBox(width: 20),
            ...categories
              .map((e) => Padding(
                padding: const EdgeInsets.only(right: 20),
                child: CategoryItem(
                  entity: e,
                  isSelected: currentSelectedItemId == e.id,
                  onSelect: () {
                    onItemSelect(e.id);
                  },
                ),
              ))
            .toList(),
          ]
        ),
      ),
    );
  }
}
