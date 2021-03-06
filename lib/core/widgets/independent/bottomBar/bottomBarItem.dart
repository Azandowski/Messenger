import 'package:flutter/material.dart';

import '../../../../app/appTheme.dart';

class BottomBarItem extends StatelessWidget {
  final int index;
  final Function(int) onChangeIndex;
  final IconData iconData;
  final bool isSelected;

  const BottomBarItem({
    @required this.onChangeIndex,
    @required this.iconData,
    @required this.index,
    this.isSelected = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: isSelected
              ? Border(
                  top: BorderSide(color: AppColors.indicatorColor, width: 2))
              : null),
      child: IconButton(
        icon: Icon(
          iconData,
          size: 30,
          color: isSelected ? AppColors.indicatorColor : Colors.grey[400],
        ),
        onPressed: () {
          onChangeIndex(index);
        },
      ),
    );
  }
}
