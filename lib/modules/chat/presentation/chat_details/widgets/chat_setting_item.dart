import 'package:flutter/material.dart';

import '../../../../../app/appTheme.dart';
import '../../../../category/domain/entities/chat_permissions.dart';

class ChatSettingItem extends StatelessWidget {
  
  final ChatSettings chatSetting;
  final bool isOn;
  final Function(bool value) onToggle;


  ChatSettingItem({
    @required this.chatSetting,
    @required this.onToggle,
    this.isOn = true
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(chatSetting.title),
      value: isOn, 
      onChanged: (bool value) {
        onToggle(value);        
      },
      activeColor: AppColors.indicatorColor,
    );
  }
}

enum ChatSettings {
  noSound, noMedia, adminSendMessage, forwardMessages
}

extension ChatSettingsUIExtension on ChatSettings {
  String get title {
    switch (this) {
      case ChatSettings.noSound:
        return 'Без звука';
      case ChatSettings.noMedia:
        return 'Без фото и видео';
      case ChatSettings.adminSendMessage:
        return 'Отправка сообщений';
      case ChatSettings.forwardMessages:
        return 'Запрет на перессылки';
      default:
        return '';
    }
  }

  bool getValue (ChatPermissions permissions) {
    switch (this) {
      case ChatSettings.noSound:
        return permissions?.isSoundOn ?? false;
      case ChatSettings.noMedia:
        return permissions?.isMediaSendOn ?? false;
      case ChatSettings.adminSendMessage:
        return permissions?.adminMessageSend ?? false;
      case ChatSettings.forwardMessages:
        return permissions?.isForwardOn ?? true;
      default:
        return false;
    }
  }

  List<String> get selectionOptions {
    switch (this) {
      case ChatSettings.adminSendMessage:        
        return [
          'Только Админы',
          'Все участники'
        ];
      case ChatSettings.noMedia:
        return [
          'Только Админы',
          'Все участники'
        ];
      case ChatSettings.forwardMessages:
        return [
          'Да',
          'Нет'
        ];
      default:
        return null;
    }
  }


  String getValueText (ChatPermissions permissions) {
    switch (this) {
      case ChatSettings.adminSendMessage:        
        return (permissions?.adminMessageSend ?? false) ? 'Только админы' : 'Все участники';
      case ChatSettings.noMedia:
        return (permissions?.isMediaSendOn ?? true) ? 'Все участники' : 'Только админы';
      case ChatSettings.forwardMessages:
        return (permissions?.isForwardOn ?? true) ? 'Нет' : 'Да';
      default:
        return null;
    }
  }

  String get hintText {
    switch (this) {
      case ChatSettings.adminSendMessage:        
        return 'Выберите, кто может отправлять сообщения в группе';
      case ChatSettings.noMedia:
        return 'Выберите, кто может отправлять фото, видео и документы в группе';
      case ChatSettings.forwardMessages:
        return 'Выберите можно ли переслать сообщения';
      default:
        return null;
    }
  }
}