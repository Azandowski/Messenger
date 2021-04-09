import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../app/appTheme.dart';
import '../../../../../core/config/auth_config.dart';
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
      if (groupAction.needsSecondUser || (groupAction.isAtLeft && !groupAction.needsSecondUser))
        Text(
          (secondUser ?? firstUser).name,
          style: AppFontStyles.black14w400,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
      SizedBox(width: 4),
      Text(
        groupAction.action.getHintText(),
        style: AppFontStyles.grey12w400.copyWith(
          fontSize: 13.0
        ),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
      ),
      SizedBox(width: 4),
      if (
        groupAction.firstUser != null && groupAction.needsSecondUser && !groupAction.isAtLeft
      )
        Flexible(
          child: Text(
            '(${firstUser?.user?.id == sl<AuthConfig>().user?.id ? "you".tr() : firstUser.name})',
            style: AppFontStyles.black14w400,
            overflow: TextOverflow.ellipsis,
          ),
        ),
    ];
  }

  List<Widget> _buildTimeAction (TimeAction action) {
    if (action.dateTime != null)
      return [
        Text(
          sl<DateHelper>().getChatDay(action.dateTime),
          style: AppFontStyles.black14w400
        )
      ];

    return [];
  }
}