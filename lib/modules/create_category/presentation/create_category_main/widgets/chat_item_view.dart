import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/create_category/domain/entities/chat_entity.dart';

class ChatItemView extends StatelessWidget {
  
  final ChatEntity entity;
  final Function(ChatItemAction) onSelectedOption;

  const ChatItemView({
    @required this.entity,
    @required this.onSelectedOption,
    Key key, 
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(entity.imageUrl),
        radius: 17.5,
      ),
      title: Text(entity.title ?? '', style: AppFontStyles.mainStyle,),
      trailing: PopupMenuButton<ChatItemAction>(
        itemBuilder: (context) => ChatItemAction.values.map((e) {
          return PopupMenuItem(
            value: e,
            child: Text(e.title)
          );
        }).toList(),
        onSelected: (ChatItemAction action) {
          onSelectedOption(action);
        }
      ),
    );
  }
}

enum ChatItemAction { delete, move }

extension ChatItemActionUIExtension on ChatItemAction {
  String get title {
    switch (this) {
      case ChatItemAction.delete:
        return 'Удалить';
      case ChatItemAction.move:
        return 'Переместить';
    }
  }
}