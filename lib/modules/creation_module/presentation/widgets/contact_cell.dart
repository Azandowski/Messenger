import 'package:flutter/material.dart';

import '../../../../app/appTheme.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/widgets/independent/images/ImageWithCorner.dart';
import '../../../../locator.dart';
import '../../domain/entities/contact.dart';

enum ContactCellType{
  delete,
  add,
  write,
}

extension ContactCellModel on ContactCellType{

IconData get trailingIcon{
  switch (this){
    case ContactCellType.delete:
      return Icons.delete;
    case ContactCellType.write:
      return Icons.message;
    default: 
      return null;
  }
}
}

class ContactCell extends StatelessWidget {
  
  final ContactEntity contactItem;
  final ContactCellType cellType;
  final bool isSelected;
  final Function onTrilinIconTapped;
  final Function onTap;

  ContactCell({
    this.cellType = ContactCellType.write,
    this.isSelected = false,
    this.onTrilinIconTapped,
    this.onTap,
    @required this.contactItem
  });
  
  @override 
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? AppColors.pinkBackgroundColor : Colors.transparent,
      child: ListTile(
        onTap: onTap,
        leading: AvatarImage(
          isFromAsset: false,
          path: contactItem.avatar,
          width: 35, height: 35,
        ),
        title: Text(
          contactItem.name ?? 'Anonymous',
          style: AppFontStyles.mediumStyle,
        ),
        subtitle: Text(
         contactItem.lastVisit != null ?  sl<DateHelper>().getLastOnlineDate(contactItem.lastVisit) : '',
          style: AppFontStyles.placeholderStyle,
        ),
        trailing: cellType.trailingIcon != null ?  IconButton(
          icon: Icon(cellType.trailingIcon),
          onPressed: onTrilinIconTapped,
        ) : SizedBox(),
      ),
    );
  }
}