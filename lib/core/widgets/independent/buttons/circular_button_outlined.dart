import 'package:flutter/material.dart';

class CircularButtonOutlined extends StatelessWidget {

  final Function() onTap;
  final String text;
  final TextStyle textStyle;
  final Color borderColor;

  CircularButtonOutlined({
    @required this.onTap, 
    @required this.text,
    @required this.textStyle,
    @required this.borderColor
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: 2
          )
        ),
        height: 40,
        child: Center(
          child: Text(
            text,
            style: textStyle
          )
        )
      ),
    );
  }
}