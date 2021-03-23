import 'package:flutter/material.dart';

import '../../../../../app/appTheme.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_action_button.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_params.dart';
import '../../../../../core/widgets/independent/dialogs/dialogs.dart';
import '../../../../category/domain/entities/chat_permissions.dart';
import 'chat_setting_item.dart';
import 'divider_wrapper.dart';

class ChatAdminSettings extends StatefulWidget {
  
  final ChatPermissions permissions;
  final Function (ChatSettings, bool) didSelectOption; 

  const ChatAdminSettings({
    @required this.permissions,
    @required this.didSelectOption,
    Key key, 
  }) : super(key: key);

  @override
  _ChatAdminSettingsState createState() => _ChatAdminSettingsState();
}

class _ChatAdminSettingsState extends State<ChatAdminSettings> {
  @override
  Widget build(BuildContext context) {
    return DividerWrapper(
      children: [
        _buildItem(
          title: ChatSettings.adminSendMessage.title,
          value: ChatSettings.adminSendMessage.getValueText(widget.permissions),
          onPress: () {
            _showDialog(
              context,
              (int newValue) {
                widget.didSelectOption(ChatSettings.adminSendMessage, newValue == 0);
              },
              ChatSettings.adminSendMessage
            );
          }
        ),
        _buildItem(
          title: ChatSettings.noMedia.title,
          value: ChatSettings.noMedia.getValueText(widget.permissions),
          onPress: () {
            _showDialog(
              context,
              (int newValue) {
                widget.didSelectOption(ChatSettings.noMedia, newValue == 0);
              },
              ChatSettings.noMedia
            );
          }
        ),
        _buildItem(
          title: ChatSettings.forwardMessages.title,
          value: ChatSettings.forwardMessages.getValueText(widget.permissions),
          onPress: () {
            _showDialog(
              context,
              (int newValue) {
                widget.didSelectOption(ChatSettings.forwardMessages, newValue == 1);
              },
              ChatSettings.forwardMessages
            );
          }
        )
      ],
    );
  }

  Widget _buildItem ({
    @required String title, 
    @required String value,
    @required Function onPress
  }) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 10,
          top: 18
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppFontStyles.black14w400,
            ),
            Text(
              value,
              style: AppFontStyles.grey14w400,
            ),
          ],
        ),
      )
    );
  }

  void _showDialog (
    BuildContext context,
    Function (int) onNewValue,
    ChatSettings settings
  ) {
    int _currentOptionIndex;

    showDialog(context: context, builder: (_) {
      return DialogsView( 
        dialogViewType: DialogViewType.optionSelector,
        title: settings.title,
        description: settings.hintText,
        optionsContainer: DialogOptionsContainer(
          options: settings.selectionOptions, 
          currentOptionIndex: null, 
          onPress: (newIndex) {
            _currentOptionIndex = newIndex;
          }
        ),
        actionButton: [
          DialogActionButton(
            buttonStyle: DialogActionButtonStyle.cancel,
            title: 'Отмена',
            onPress: () {
              Navigator.of(context).pop();
            }
          ),
          DialogActionButton(
            buttonStyle: DialogActionButtonStyle.submit,
            title: 'Готово',
            onPress: () {
              Navigator.of(context).pop();
              onNewValue(_currentOptionIndex);
            }
          )
        ]
      );
    });
  }
}
