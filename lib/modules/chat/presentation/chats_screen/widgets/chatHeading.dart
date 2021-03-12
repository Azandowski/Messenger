import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/widgets/independent/images/ImageWithCorner.dart';

import 'marqueText.dart';


class ChatHeading extends StatelessWidget {
  final Function onTap; 
  final String avatarURL;
  final String title;
  final String description;
  
  
  const ChatHeading({
    @required this.onTap,
    this.title,
    this.description,
    this.avatarURL,
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
          AvatarImage(
            isFromAsset: false,
            path: avatarURL,
            width: 35,
            height: 35,
            borderRadius: BorderRadius.circular(17.5)
          ),
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
                      text: title ?? '',
                      style: AppFontStyles.mediumStyle,
                    ),
                  ), 
                  if(description != null && description != '') Container(
                    height: 18,
                    child: MarqueText(
                      text: description ?? '',
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