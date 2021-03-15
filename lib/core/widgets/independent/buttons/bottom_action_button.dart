import 'package:flutter/material.dart';

import 'gradient_main_button.dart';

class BottomActionButtonContainer extends StatelessWidget {
  final Function onTap;
  final String title;
  final bool isLoading;

  const BottomActionButtonContainer({
    @required this.onTap,
    @required this.title,
    this.isLoading = false,
    Key key, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ! Should be used inside the Stack Widget
    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16
        ),
        child: ActionButton(
          text: title,
          onTap: onTap,
          isLoading: isLoading
        ),
      )
    );
  }
}