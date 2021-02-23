import 'package:flutter/material.dart';

import '../../../../app/appTheme.dart';

class LoadWidget extends StatelessWidget {
  final double size;

  const LoadWidget({Key key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: size == null
          ? buildSpinner()
          : SizedBox(width: size, height: size, child: buildSpinner()),
    );
  }

  Widget buildSpinner() {
    return CircularProgressIndicator(
      backgroundColor: AppColors.indicatorColor,
      valueColor: new AlwaysStoppedAnimation<Color>(AppColors.secondary),
    );
  }
}
