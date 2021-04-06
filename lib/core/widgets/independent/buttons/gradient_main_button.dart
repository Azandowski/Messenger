import 'package:flutter/material.dart';

import '../../../../app/appTheme.dart';
import '../placeholders/load_widget.dart';

enum ActionButtonType { gradient, outline, transparent }

enum ActionButtonSize { big, medium }

extension ActionButtonSizeExtension on ActionButtonSize {
  double get verticalPadding {
    if (this == ActionButtonSize.big) {
      return 16;
    } else if (this == ActionButtonSize.medium) {
      return 10;
    }
  }
}

class ActionButton extends StatelessWidget {
  ActionButton({
    @required this.text,
    @required this.onTap,
    this.doNotApplyWidth = false,
    this.type = ActionButtonType.gradient,
    this.textColor,
    this.size = ActionButtonSize.big,
    this.borderColor,
    this.isLoading = false,
  });

  final bool isLoading;
  final text;
  final VoidCallback onTap;
  final ActionButtonType type;
  final bool doNotApplyWidth;
  final Color textColor;
  final Color borderColor;
  final ActionButtonSize size;

  BoxDecoration getDecorationBox(ThemeData theme) {
    var border = BorderSide(color: borderColor ?? Color.fromRGBO(118, 82, 216, 1), width: 1);
    
    if (type == ActionButtonType.gradient) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: AppGradinets.mainButtonGradient,
      );
    } else if (type == ActionButtonType.outline) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border(bottom: border, top: border, left: border, right: border),
      );
    } else if (type == ActionButtonType.transparent) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      decoration: getDecorationBox(Theme.of(context)),
      child: Material(
        borderRadius: BorderRadius.circular(25),
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.white60,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: size.verticalPadding),
            width: doNotApplyWidth ? null : w - 32,
            child: isLoading
              ? LoadWidget(
                size: 20,
              ) : Center(
                child: Text(text,
                  textAlign: TextAlign.center,
                  style: AppFontStyles.actionButtonStyle.copyWith(
                    color: textColor ?? Colors.white
                  )
                ),
              ),
          ),
        ),
      ),
    );
  }
}
