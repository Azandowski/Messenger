import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/services/network/config.dart';

import '../../../../app/appTheme.dart';
import '../../../../core/widgets/independent/images/ImageWithCorner.dart';
import '../../domain/entities/category.dart';

class CategoryItem extends StatelessWidget {
  final CategoryEntity entity;
  bool isSelected;
  final Function onSelect;

  CategoryItem({
    @required this.entity,
    @required this.onSelect,
    this.isSelected = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        width: 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AvatarImage(
              borderRadius: BorderRadius.circular(15),
              path: ConfigExtension.buildURLHead() +  entity.avatar,
              isFromAsset: false,
              width: 80,
              height: 80,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              entity.name,
              style: AppFontStyles.headerMediumStyle,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isSelected ? AppColors.indicatorColor : null),
              height: 6,
            )
          ],
        ),
      ),
    );
  }
}
