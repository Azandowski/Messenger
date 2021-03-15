import 'package:flutter/material.dart';

import '../../../../../app/appTheme.dart';
import '../../../../creation_module/domain/entities/contact.dart';
import '../../../../creation_module/presentation/widgets/contact_cell.dart';
import 'divider_wrapper.dart';

class ChatMembersBlock extends StatelessWidget {
  final List<ContactEntity> members;
  final int membersCount;
  final Function onShowMoreClick;

  const ChatMembersBlock({
    @required this.members,
    @required this.membersCount,
    @required this.onShowMoreClick,
    Key key, 
  }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {  
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
          contactItem: e
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