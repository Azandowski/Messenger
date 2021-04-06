import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircullarUploadIndicator extends StatelessWidget {
  const CircullarUploadIndicator({
    Key key,
    @required this.percent,
    @required this.radius,
  }) : super(key: key);

  final double percent;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      percent: percent,
      radius: radius,
      progressColor: AppColors.successGreenColor,
      backgroundColor: Colors.white,
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(
        (percent * 100).floor().toString() + '%',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }
}