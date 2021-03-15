

import 'package:flutter/material.dart';

class ChildDetailAppBar extends StatelessWidget {
  
  final Function onPressRightIcon;
  final Function onPressLeftIcon;
  final bool canEdit;

  const ChildDetailAppBar({
    @required this.onPressRightIcon,
    @required this.onPressLeftIcon,
    @required this.canEdit,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top, left: 8, right: 8),
        color: Color.fromRGBO(0, 0, 0, 0.3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                onPressLeftIcon();
              },
            ),
            if (canEdit)
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  onPressRightIcon();
                },
              )
          ],
        ),
      )
    );
  }
}