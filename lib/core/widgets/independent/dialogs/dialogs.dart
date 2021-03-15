import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

import '../../../../app/appTheme.dart';
import '../../../utils/feedbac_taptic_helper.dart';
import 'dialog_action_button.dart';
import 'dialog_params.dart';

/// * Reusable dialogs for the whole application

class DialogsView extends StatefulWidget {

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
    this.optionsContainer,
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

  /// List of option's titles only for [DialogViewType.optionSelector]
  final DialogOptionsContainer optionsContainer;

  /// Background color of the whole alert view, by default it's [Colors.white]
  final Color backgroundColor;

  @override
  _DialogsViewState createState() => _DialogsViewState(
    optionsContainer: optionsContainer
  );
}

class _DialogsViewState extends State<DialogsView> {
  
    /// List of option's titles only for [DialogViewType.optionSelector]
  DialogOptionsContainer optionsContainer;

  _DialogsViewState({
    this.optionsContainer
  });

  /// Rendering 
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      elevation: 0,
      backgroundColor: widget.backgroundColor ?? Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12))
        ),
        padding: widget.dialogViewType != DialogViewType.actionSheet ? 
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
        if (widget.imageProvider != null)
          ...[
            _buildTopImageView(),
            SizedBox(height: 20,)
          ],
        if (widget.title != null || widget.description != null || widget.customDescription != null)
          _buildDialogBody(),
        if (widget.optionsContainer != null)
          ...[
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: _buildOptionSelector(),
              ),
            )
          ],
        if (widget.actionButton != null) 
          ...[
            SizedBox(height: 10,),
            _buildActionButtons()
          ],
      ],
    );
  }

  /// Builds top Image View
  Widget _buildTopImageView () {
    return Image(
      image: widget.imageProvider,
      width: 135,
      height: 135,
    );
  }

  /// Builds the main content of the dialog view
  /// It is a Column which contains [Title] and [Description] of the alert
  Widget _buildDialogBody () {
    return Column(
      children: [
        if (widget.title != null)
          ...[
            Text(
              widget.title ?? '',
              style: widget.titleStyle ?? AppFontStyles.headerMediumStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10,)
          ],
        if (widget.description != null || widget.customDescription != null)
          ...[
            widget.customDescription ?? 
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: widget.descriptionStyle ?? TextStyle(
                fontSize: 13, color: Colors.grey[700]
              ),
            ),
            SizedBox(height: 10,)
          ]
      ],
    );
  }

  /// Returns action buttons as the one widget
  Widget _buildActionButtons () {
    if (widget.buttonsLayout == DialogViewButtonsLayout.horizontal && widget.dialogViewType != DialogViewType.actionSheet) {
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

    widget.actionButton.forEach((button) { 
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
    } else if (widget.dialogViewType != DialogViewType.actionSheet) {
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
          onTap: () {
            FeedbackEngine.showFeedback(FeedbackType.selection);
            buttonDetails.onPress();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                if (buttonDetails.iconData != null)
                  ...[
                    Icon(
                      buttonDetails.iconData,
                      color: buttonDetails.buttonStyle.textColor,
                    ),
                    SizedBox(width: 12),
                  ],
                Text(
                  buttonDetails.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: buttonDetails.buttonStyle.textColor
                  ),
                ),
              ],
            ),
          )
        ),
      );
    }
  }

  List<Widget> _buildOptionSelector () {
    List<Widget> widgets = [];

    for (int i = 0; i < optionsContainer.options.length; i++) {
      widgets.add(GestureDetector(
        onTap: () {
          setState(() {
            optionsContainer = DialogOptionsContainer(
              options: optionsContainer.options, 
              currentOptionIndex: i, 
              onPress: optionsContainer.onPress
            );
          });
          optionsContainer.onPress(i);
        },
        child: _buildOption(optionsContainer.options[i], optionsContainer.currentOptionIndex == i)
      ));
    }

    return widgets;
  }

  Widget _buildOption (String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.lens_outlined,
            color: isSelected ? Colors.green : Colors.black
          ),
          SizedBox(width: 12),
          Text(title)
        ],
      ),
    );
  }
}