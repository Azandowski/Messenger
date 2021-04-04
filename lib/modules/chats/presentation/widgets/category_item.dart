import 'package:flutter/material.dart';

import '../../../../app/appTheme.dart';
import '../../../../core/widgets/independent/images/ImageWithCorner.dart';
import '../../domain/entities/category.dart';
import 'chat_item/chat_notification_view.dart';

class CategoryItem extends StatelessWidget {
  final CategoryEntity entity;
  bool isSelected;
  final Function onSelect;
  final bool isAvatarFromAssets;

  CategoryItem({
    @required this.entity,
    @required this.onSelect,
    this.isSelected = false,
    this.isAvatarFromAssets = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Container(
        width: 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                AvatarImage(
                  borderRadius: BorderRadius.circular(15),
                  path: entity.avatar,
                  isFromAsset: isAvatarFromAssets,
                  width: 80,
                  height: 80,
                ),
                if (entity.noReadCount != 0 && entity.noReadCount != null) 
                  Positioned(
                    top: 8,
                    right: 8,
                    child: ChatNotificationView(
                      badgeCount: entity.noReadCount
                    ),
                  ),
              ],
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
