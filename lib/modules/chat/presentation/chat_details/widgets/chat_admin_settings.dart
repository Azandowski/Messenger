import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_setting_item.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/divider_wrapper.dart';

class ChatAdminSettings extends StatelessWidget {
  
  final ChatPermissions permissions;

  const ChatAdminSettings({
    @required this.permissions,
    Key key, 
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return DividerWrapper(
      children: [
        _buildItem(
          title: 'Отправка сообщений',
          value: ChatSettings.adminSendMessage.getValueText(permissions)
        )
      ],
    );
  }

  Widget _buildItem ({
    @required String title, 
    @required String value
  }) {
    return ListTile(
      title: Text(title),
      trailing: Text(value),
    );
  }
}