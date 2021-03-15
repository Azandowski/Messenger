import 'package:flutter/material.dart';

import '../../../../../core/widgets/independent/dialogs/dialog_action_button.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_params.dart';
import '../../../../../core/widgets/independent/dialogs/dialogs.dart';
import '../../../../category/domain/entities/chat_permissions.dart';
import 'chat_setting_item.dart';
import 'divider_wrapper.dart';

class ChatAdminSettings extends StatefulWidget {
  
  final ChatPermissions permissions;


  const ChatAdminSettings({
    @required this.permissions,
    Key key, 
  }) : super(key: key);

  @override
  _ChatAdminSettingsState createState() => _ChatAdminSettingsState();
}

class _ChatAdminSettingsState extends State<ChatAdminSettings> {

  final Function (ChatSettings, bool) didSelectOption; 

  _ChatAdminSettingsState ({
    @required this.didSelectOption
  });

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

              },
              ChatSettings.adminSendMessage
            );
          }
        ),
        // _buildItem(
        //   title: ChatSettings.noMedia.title,
        //   value: ChatSettings.noMedia.getValueText(widget.permissions),
        //   context: context
        // )
      ],
    );
  }

  Widget _buildItem ({
    @required String title, 
    @required String value,
    @required Function onPress
  }) {
    return GestureDetector(
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
            Text(title),
            Text(value),
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
    int _currentOptionIndex = 0;

    showDialog(context: context, builder: (_) {
      return DialogsView( 
        dialogViewType: DialogViewType.optionSelector,
        title: 'Отправка сообщений',
        description: 'Выберите, кто может отправлять сообщения в группе',
        optionsContainer: DialogOptionsContainer(
          options: settings.selectionOptions, 
          currentOptionIndex: 0, 
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
