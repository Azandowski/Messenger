import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/utils/date_helper.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_actions.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/helpers/message_user_viewmodel.dart';

import '../../../../../app/appTheme.dart';
import '../../../../../core/utils/date_helper.dart';
import '../../../../../locator.dart';
import '../../../domain/entities/chat_actions.dart';
import '../helpers/message_user_viewmodel.dart';

class ChatActionView extends StatelessWidget {
  
  final ChatAction chatAction;

  ChatActionView({
    @required this.chatAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildContent()
      ) 
    );
  }

  List<Widget> _buildContent () {
    if (chatAction is GroupAction) {
      return _buildGroupAction(chatAction);
    } else if (chatAction is TimeAction) {
      return _buildTimeAction(chatAction);
    } else {
      return [];
    }
  }

  List<Widget> _buildGroupAction (GroupAction groupAction) {
    final firstUser = MessageUserViewModel(groupAction.firstUser);
    final secondUser = MessageUserViewModel(groupAction.secondUser);
    return [
      if (groupAction.action.imagePath != null) 
        ...[
          Image.asset(
            groupAction.action.imagePath,
            width: 12,
            height: 15
          ),
          SizedBox(width: 8)
        ],
      Text(
        firstUser.name,
        style: AppFontStyles.black14w400
      ),
      SizedBox(width: 4),
      Text(
        groupAction.action.getHintText(
          firstUser?.user?.id == sl<AuthConfig>().user?.id
        ),
        style: AppFontStyles.grey12w400.copyWith(
          fontSize: 13.0
        )
      ),
      SizedBox(width: 4),
      if (groupAction.secondUser != null)
        Text(
          secondUser.name,
          style: AppFontStyles.black14w400
        ),
    ];
  }

  List<Widget> _buildTimeAction (TimeAction action) {
    return [
      Text(
        sl<DateHelper>().getChatDay(action.dateTime),
        style: AppFontStyles.black14w400
      )
    ];
  }
}