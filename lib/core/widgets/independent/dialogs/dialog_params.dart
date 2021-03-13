import 'dart:ui';

import 'package:flutter/material.dart';

enum DialogViewButtonsLayout { 
  horizontal, vertical
}

enum DialogViewType {
  alert, actionSheet, optionSelector
}

enum DialogActionButtonStyle {
  dangerous, cancel, submit, custom, black
}

extension DialogActionButtonStyleUIExtension on DialogActionButtonStyle {
  Color get textColor {
    switch (this) {
      case DialogActionButtonStyle.dangerous:
        return Colors.red;
      case DialogActionButtonStyle.cancel:
        return Colors.grey;
      case DialogActionButtonStyle.submit:
        return Color(0xff9357CD);
      case DialogActionButtonStyle.black:
        return Colors.black;
      default:
        return null;
    }
  }
}