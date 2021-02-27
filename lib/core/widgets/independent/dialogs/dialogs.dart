import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/widgets/independent/dialogs/dialog_action_button.dart';
import 'package:messenger_mobile/core/widgets/independent/dialogs/dialog_params.dart';

/// * Reusable dialogs for the whole application

class DialogsView extends StatelessWidget {

  /// Default constuctor  
  DialogsView({
    this.dialogViewType = DialogViewType.alert,
    this.imageProvider, 
    this.title, 
    this.titleStyle, 
    this.customDescription,
    this.description, 
    this.descriptionStyle, 
    this.buttonsLayout = DialogViewButtonsLayout.horizontal, 
    this.actionButton,
    this.backgroundColor,
    Key key, 
  }) : super(key: key);

  /// Type of the current dialog view
  /// [DialogViewType.actionSheet] - is needed only to show list of actions, whereas
  /// [DialogViewType.alert] can display texts, actions, images
  /// [DialogViewType.actionSheet] can contains icons in buttons, so use it only for that case
  final DialogViewType dialogViewType;

  /// Provider of the image, which will be at the top of the alert view
  final ImageProvider imageProvider;

  /// Text of the title 
  final String title;

  /// Custom Text Style of the title, by default uses main style of application
  final TextStyle titleStyle;

  /// Custom Description widget
  final Widget customDescription;

  /// Description of the alert view, if null then will be hidden
  final String description;

  /// Custom Text style of the description, by default uses application style
  final TextStyle descriptionStyle;

  /// Layout of the buttons, by default is [DialogViewButtonsLayout.horizontal]
  /// But if dialog style if [DialogViewType.actionSheet] this property will be [ignored]
  final DialogViewButtonsLayout buttonsLayout;

  /// List of parameters of the buttons of the alert view
  final List<DialogActionButton> actionButton;

  /// Background color of the whole alert view, by default it's [Colors.white]
  final Color backgroundColor;

  /// Rendering 
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      elevation: 0,
      backgroundColor: backgroundColor ?? Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12))
        ),
        padding: dialogViewType == DialogViewType.alert ? 
          EdgeInsets.symmetric(vertical: 30, horizontal: 16) : null,
        child: _buildDialogView(),
      )
    );
  }


  /// Creates inner content of the Dialog View
  Widget _buildDialogView () {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (imageProvider != null)
          ...[
            _buildTopImageView(),
            SizedBox(height: 20,)
          ],
        if (title != null || description != null || customDescription != null)
          _buildDialogBody(),
        if (actionButton != null) 
          ...[
            SizedBox(height: 10,),
            _buildActionButtons()
          ]
      ],
    );
  }

  /// Builds top Image View
  Widget _buildTopImageView () {
    return Image(
      image: imageProvider,
      width: 135,
      height: 135,
    );
  }

  /// Builds the main content of the dialog view
  /// It is a Column which contains [Title] and [Description] of the alert
  Widget _buildDialogBody () {
    return Column(
      children: [
        if (title != null)
          ...[
            Text(
              title ?? '',
              style: titleStyle ?? AppFontStyles.mainStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10,)
          ],
        if (description != null || customDescription != null)
          ...[
            customDescription ?? 
            Text(
              description,
              textAlign: TextAlign.center,
              style: descriptionStyle ?? TextStyle(
                fontSize: 13, color: Colors.grey[700]
              ),
            ),
            SizedBox(height: 10,)
          ]
      ],
    );
  }

  // * * Rendering Action Buttons for the alert view

  /// Returns action buttons as the one widget
  Widget _buildActionButtons () {
    if (buttonsLayout == DialogViewButtonsLayout.horizontal && dialogViewType == DialogViewType.alert) {
      return Row(
        children: _buildContentOfActionButtons(),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildContentOfActionButtons(needsSpacing: true),
      );
    }
  }

  /// Returns list of buttons (as the [Widget]) from the [DialogActionButton] list
  List<Widget> _buildContentOfActionButtons ({
    bool needsSpacing = false
  }) {
    List<Widget> buttons = [];

    actionButton.forEach((button) { 
      buttons.add(_buildActionButton(button));

      if (needsSpacing) {
        buttons.add(
          SizedBox(height: 10)
        );
      }
    });

    return buttons;
  }

  /// Returns Widget, which is a action button
  /// Style of the button depends on the [DialogActionButton] class
  /// If the [DialogActionButton] is custom button, then it returns it's [customButton]
  /// It is already wrapped with [GestureDetector] and implements [onTap] method
  Widget _buildActionButton (DialogActionButton buttonDetails) {
    if (buttonDetails.buttonStyle == DialogActionButtonStyle.custom) {
      return buttonDetails.customButton;
    } else if (dialogViewType == DialogViewType.alert) {
      // Building simple button for the alert view
      return Flexible(
        child: GestureDetector(
          onTap: buttonDetails.onPress,
          child: Container(
            child: Center(
              child: Text(
                buttonDetails.title.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: buttonDetails.buttonStyle.textColor
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      // Building button for the action sheet
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1, color: Colors.grey[300]
            )
          )
        ),
        child: GestureDetector(
          onTap: buttonDetails.onPress,
          child: ListTile(
            leading: buttonDetails.iconData != null ? 
              Icon(
                buttonDetails.iconData,
                color: buttonDetails.buttonStyle.textColor,
              ) : null,
            title: Text(
              buttonDetails.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: buttonDetails.buttonStyle.textColor
              )
            ),
          ),
        ),
      );
    }
  }
}