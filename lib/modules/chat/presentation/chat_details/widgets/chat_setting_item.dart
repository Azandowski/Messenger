import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';

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
  noSound, noMedia
}

extension ChatSettingsUIExtension on ChatSettings {
  String get title {
    switch (this) {
      case ChatSettings.noSound:
        return 'Без звука';
      case ChatSettings.noMedia:
        return 'Без фото и видео';
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
      default:
        return false;
    }
  }
}