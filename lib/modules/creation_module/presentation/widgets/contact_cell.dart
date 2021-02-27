import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/utils/date_helper.dart';
import 'package:messenger_mobile/core/widgets/independent/images/ImageWithCorner.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';

import '../../../../locator.dart';

class ContactCell extends StatelessWidget {
  
  final Contact contactItem;

  ContactCell({
    @required this.contactItem
  });
  
  @override 
  Widget build(BuildContext context) {
    return ListTile(
      leading: AvatarImage(
        isFromAsset: false,
        path: contactItem.avatarURL,
        width: 35, height: 35,
      ),
      title: Text(
        contactItem.name,
        style: AppFontStyles.mediumStyle,
      ),
      subtitle: Text(
        sl<DateHelper>().getLastOnlineDate(contactItem.lastOnline),
        style: AppFontStyles.placeholderStyle,
      ),
      trailing: Icon(
        Icons.message_outlined
      ),
    );
  }
}