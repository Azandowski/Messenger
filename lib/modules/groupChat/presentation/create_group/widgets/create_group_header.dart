import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/widgets/independent/buttons/icon_text_button.dart';
import '../../../../../core/widgets/independent/small_widgets/photo_picker_view.dart';
import '../../../../../core/widgets/independent/textfields/customTextField.dart';

class CreateGroupHeader extends StatelessWidget {
  
  final ImageProvider imageProvider;
  final Function(File) selectImage;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final Function onAddContacts;

  const CreateGroupHeader({
    @required this.imageProvider, 
    @required this.selectImage,
    @required this.nameController,
    @required this.descriptionController,
    @required this.onAddContacts,
    Key key
  }) : super(key: key);

  @override
  Widget build(Object context) {  
    return Column(
      children: [
        PhotoPickerView(
          defaultPhotoProvider: imageProvider,
          onSelectPhoto: () {
            selectImage(null);
          }
        ),
        CustomTextField(
          textCtr: nameController,
          labelText: 'group_name'.tr(),
          customPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
        ),
        CustomTextField(
          textCtr: descriptionController,
          labelText: 'description_unoptional'.tr(),
          customPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
        ),
        IconTextButton(
          imageAssetPath: 'assets/images/chat_gradient_icon.png',
          onPress: onAddContacts,
          title: 'add_contacts'.tr(),
        )
      ],
    );
  }
}