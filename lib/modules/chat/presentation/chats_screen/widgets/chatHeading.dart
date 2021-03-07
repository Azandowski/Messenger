import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';

import 'marqueText.dart';


class ChatHeading extends StatelessWidget {
  final Function onTap; 
  const ChatHeading({
    @required this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(backgroundImage: AssetImage(
            'assets/images/default_user.jpg'
          ),),
          SizedBox(width: 8,),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 18,
                    child: MarqueText(
                      text: 'Alex and Someone adas',
                      style: AppFontStyles.mediumStyle,
                    ),
                  ), 
                  Container(
                    height: 18,
                    child: MarqueText(
                      text: 'Alex and Someone',
                      style: AppFontStyles.placeholderStyle,
                    ),
                  ), 
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}