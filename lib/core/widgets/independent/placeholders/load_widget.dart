import 'package:flutter/material.dart';

import '../../../../app/appTheme.dart';

class LoadWidget extends StatelessWidget {
  final double size;
  final bool inCenter;

  const LoadWidget({
    this.size, 
    this.inCenter = true,
    Key key, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget spinner = size == null
      ? buildSpinner()
      : SizedBox(width: size, height: size, child: buildSpinner());
      
    return inCenter ? Center(
      child: spinner
    ) : spinner;
  }

  Widget buildSpinner() {
    return CircularProgressIndicator(
      backgroundColor: AppColors.indicatorColor,
      valueColor: new AlwaysStoppedAnimation<Color>(AppColors.secondary),
    );
  }
}
