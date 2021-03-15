import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/divider_wrapper.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/widgets/contact_cell.dart';

import '../../../../../locator.dart';

class ChatMembersBlock extends StatelessWidget {
  final List<ContactEntity> members;
  final int membersCount;
  final Function onShowMoreClick;
  final Function(ContactEntity) onTapItem;

  const ChatMembersBlock({
    @required this.members,
    @required this.membersCount,
    @required this.onShowMoreClick,
    @required this.onTapItem,
    Key key, 
  }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {  
    var currentUserID = sl<AuthConfig>().user.id;

    return DividerWrapper(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Участники: ',
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: '$membersCount',
                    style: TextStyle(color: AppColors.indicatorColor)
                  )
                ]
              ),
            ),
          ),
        ),
        ...members.map((e) => ContactCell(
          contactItem: e,
          cellType: currentUserID == e.id ? ContactCellType.write :
            ContactCellType.delete,
          onTrilinIconTapped: () {
            onTapItem(e);
          },
        )).toList(),
        _buildSubmitButton()
      ]
    );
  }

  Widget _buildSubmitButton () {
    return GestureDetector (
      onTap: onShowMoreClick,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16
        ),
        child: Text(
          'Открыть весь список участников',
          textAlign: TextAlign.left,
          style: TextStyle(color: AppColors.indicatorColor, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}