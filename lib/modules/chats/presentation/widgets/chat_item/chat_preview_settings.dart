import 'package:flutter/material.dart';

import '../../../../../app/appTheme.dart';
import '../../../../category/data/models/chat_view_model.dart';


extension ChatSettingTypeExtension on ChatSettingType {
  IconData get iconData {
    switch (this) {
      case ChatSettingType.muted:
        return Icons.volume_off;
      case ChatSettingType.pinned:
        return Icons.push_pin;
      case ChatSettingType.hideImages:
        return Icons.broken_image;
    }
  }
}

class ChatPreviewSettings extends StatelessWidget {
  
  final String dateString;
  final List<ChatSettingType> settings;

  const ChatPreviewSettings({
    @required this.dateString,
    @required this.settings,
    Key key, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ..._buildSettingsPins(),
        Text(
          dateString,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.indicatorColor
          )
        )
      ],
    );
  }

  List<Widget> _buildSettingsPins () {
    List<Widget> widgets = [];
    settings.forEach((item) {
      widgets.add(Icon(
        item.iconData,
        size: 16,
        color: Colors.grey,
      ));
      widgets.add(SizedBox(width: 4,));
    });

    return widgets;
  }
}