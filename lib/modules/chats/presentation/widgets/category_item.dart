import 'package:flutter/material.dart';

import '../../../../app/appTheme.dart';
import '../../../../core/widgets/independent/images/ImageWithCorner.dart';
import '../../domain/entities/category.dart';

class CategoryItem extends StatelessWidget {
  final CategoryEntity entity;
  bool isSelected;

  CategoryItem({
    @required this.entity,
    this.isSelected = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AvatarImage(
            borderRadius: BorderRadius.circular(15),
            path: entity.avatar,
            isFromAsset: false,
            width: 80,
            height: 80,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            entity.name,
            style: AppFontStyles.mainStyle,
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
    );
  }
}
