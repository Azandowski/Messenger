import 'package:flutter/material.dart';

import 'dialog_params.dart';

class DialogActionButton {
  
  DialogActionButton ({
    @required this.buttonStyle,
    this.onPress,
    this.title,
    this.customButton,
    this.iconData
  }) {
    if (buttonStyle == DialogActionButtonStyle.custom) {
      assert(customButton != null, 'Custom Button Widget should not be null');
    } else {
      assert(title != null, 'title should not be null');
      assert(onPress != null, 'onPress should be implemented');
    }
  }

  /// Title of the button
  final String title;

  /// Type of the button, it is required parameter
  final DialogActionButtonStyle buttonStyle;

  /// This is a custom button widget, which is needed if buttonStyle is a [DialogActionButtonStyle.custom]
  final Widget customButton;

  /// This is a [IconData] needed for the icon if the style of the alert is a [DialogViewType.actionSheet]
  final IconData iconData;

  /// This is callback button which will be called if user taps on the button;
  final Function onPress;
}