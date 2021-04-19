import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../app/appTheme.dart';
import '../../../../../core/config/auth_config.dart';
import '../../../../../locator.dart';
import '../../../../creation_module/domain/entities/contact.dart';
import '../../../../creation_module/presentation/widgets/contact_cell.dart';
import '../../../domain/entities/chat_detailed.dart';
import 'divider_wrapper.dart';

class ChatMembersBlock extends StatelessWidget {
  final List<ContactEntity> members;
  final int membersCount;
  final Function onShowMoreClick;
  final Function(ContactEntity) onTapItem;
  final ChatMember memberRole;

  const ChatMembersBlock({
    @required this.members,
    @required this.membersCount,
    @required this.onShowMoreClick,
    @required this.onTapItem,
    @required this.memberRole,
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
                text: 'members'.tr() + ": ",
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
          cellType: currentUserID != e.id && 
              memberRole != ChatMember.admin ? ContactCellType.write :
            ContactCellType.delete,
          onTrilinIconTapped: () {
            onTapItem(e);
          },
        )).toList(),
        if (members.length != membersCount)
          _buildSubmitButton()
      ]
    );
  }

  Widget _buildSubmitButton () {
    return InkWell (
      onTap: onShowMoreClick,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16
        ),
        child: Text(
          'show_all_members'.tr(),
          textAlign: TextAlign.left,
          style: TextStyle(color: AppColors.indicatorColor, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}