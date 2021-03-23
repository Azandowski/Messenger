import 'package:flutter/material.dart';

import '../../../../app/appTheme.dart';

class IconTextButton extends StatelessWidget {
  final String imageAssetPath;
  final String title;
  final Function onPress;

  IconTextButton ({
    @required this.imageAssetPath,
    @required this.title,
    @required this.onPress
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image(
              image: AssetImage(imageAssetPath),
              width: 35,
              height: 35,
            ),
            SizedBox(width: 20),
            Text(
              title,
              style: AppFontStyles.headerMediumStyle,
            )
          ],
        ),
      ),
    );
  } 
}