import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class MarqueText extends StatelessWidget {
  final String text;
  final TextStyle style;
  const MarqueText({
    @required this.text,
    @required this.style,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Marquee(
      text:text,
      style: style,
      scrollAxis: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      blankSpace: 8.0,
      velocity: 15.0,
      showFadingOnlyWhenScrolling: false,
      accelerationDuration: Duration(seconds: 1),
      accelerationCurve: Curves.bounceOut,
      decelerationDuration: Duration(milliseconds: 500),
      decelerationCurve: Curves.easeOut,
    );
  }
}