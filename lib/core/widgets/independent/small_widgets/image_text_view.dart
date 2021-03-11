import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';

class EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImageTextView(
      imageProvider: AssetImage('assets/images/empty.png'),
      text: 'В этой категории еще нет чатов.\nСоздайте новую.',
    );
  }
}


class ImageTextView extends StatelessWidget {
  
  final ImageProvider imageProvider;
  final String text;

  const ImageTextView({
    @required this.imageProvider, 
    @required this.text,
    Key key, 
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      child: Column(
        children: [
          Image(
            image: imageProvider,
          ),
          SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppFontStyles.grey14w400,
          )
        ],
      ),
    );
  }
}