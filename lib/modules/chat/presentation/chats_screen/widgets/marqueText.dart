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
    return LayoutBuilder(
      builder: (context, box) {
        if (_textSize(text, style).width > box.biggest.width) {
          return Marquee(
            text: text,
            style: style,
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 8.0,
            velocity: text.length.toDouble(),
            showFadingOnlyWhenScrolling: false,
            accelerationDuration: Duration(seconds: 1),
            accelerationCurve: Curves.bounceOut,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          );
        } else {
          return Text(
            text,
            style: style
          );
        }
      }
    );
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}