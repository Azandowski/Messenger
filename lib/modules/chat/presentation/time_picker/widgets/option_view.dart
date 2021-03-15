
import 'package:flutter/material.dart';

import '../../../../../app/appTheme.dart';

class OptionView extends StatelessWidget {
  final bool isSelected;
  final String text;
  final Function onPressed;

  OptionView({
    @required this.isSelected,
    @required this.text,
    @required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16, horizontal: 16
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text, 
              style: AppFontStyles.mediumStyle,
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: isSelected ? AppColors.indicatorColor : Colors.grey[200]
              ),
              child: Icon(
                Icons.done,
                color: Colors.white,
                size: 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}


