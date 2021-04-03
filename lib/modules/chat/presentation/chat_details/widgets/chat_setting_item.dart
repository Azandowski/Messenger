import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
        return 'no_sound'.tr();
      case ChatSettings.noMedia:
        return 'no_media'.tr();
      case ChatSettings.adminSendMessage:
        return 'send_message'.tr();
      case ChatSettings.forwardMessages:
        return 'forward_restriction'.tr();
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
          'only_admins'.tr(),
          'all_members'.tr()
        ];
      case ChatSettings.noMedia:
        return [
          'only_admins'.tr(),
          'all_members'.tr()
        ];
      case ChatSettings.forwardMessages:
        return [
          'yes'.tr(),
          'no'.tr()
        ];
      default:
        return null;
    }
  }


  String getValueText (ChatPermissions permissions) {
    switch (this) {
      case ChatSettings.adminSendMessage:        
        return (permissions?.adminMessageSend ?? false) ? 'only_admins'.tr() : 'all_members'.tr();
      case ChatSettings.noMedia:
        return (permissions?.isMediaSendOn ?? true) ? 'all_members'.tr() : 'only_admins'.tr();
      case ChatSettings.forwardMessages:
        return (permissions?.isForwardOn ?? true) ? 'no'.tr() : 'yes'.tr();
      default:
        return null;
    }
  }

  String get hintText {
    switch (this) {
      case ChatSettings.adminSendMessage:        
        return 'send_message_permission_hint'.tr();
      case ChatSettings.noMedia:
        return 'send_media_permission_hint'.tr();
      case ChatSettings.forwardMessages:
        return 'forward_permission_hint'.tr();
      default:
        return null;
    }
  }
}