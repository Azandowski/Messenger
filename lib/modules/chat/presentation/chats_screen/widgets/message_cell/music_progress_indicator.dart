import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';

class MusicProgressIndicator extends StatelessWidget {
  const MusicProgressIndicator({
    Key key,
    @required this.value,
    @required this.isMine,
  }) : super(key: key);

  final double value;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        height: 5,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: isMine ? Colors.white : Colors.black12,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.successGreenColor),
          ),
        ),
      ),
    );
  }
}