import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/gradient_main_button.dart';

class BottomActionButtonContainer extends StatelessWidget {
  final Function onTap;
  final String title;

  const BottomActionButtonContainer({
    @required this.onTap,
    @required this.title,
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
          vertical: 8,
          horizontal: 16
        ),
        child: ActionButton(
          text: title,
          onTap: onTap,
        ),
      )
    );
  }
}