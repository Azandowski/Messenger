import 'dart:io';

import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import '../../../../../app/appTheme.dart';
import '../../../../../core/widgets/independent/small_widgets/photo_picker_view.dart';
import '../../../../../core/widgets/independent/textfields/customTextField.dart';

class CreateCategoryHeader extends StatelessWidget {
  final ImageProvider imageProvider;
  final Function(File) selectImage;
  final TextEditingController nameController;
  final Function onAddChats;

  const CreateCategoryHeader(
      {@required this.imageProvider,
      @required this.selectImage,
      @required this.nameController,
      @required this.onAddChats,
      Key key})
      : super(key: key);

  @override
  Widget build(Object context) {
    return Column(
      children: [
        PhotoPickerView(
            defaultPhotoProvider: imageProvider,
            onSelectPhoto: () {
              selectImage(null);
            }),
        CustomTextField(
          textCtr: nameController,
          labelText: 'categoryName'.tr(),
        ),
        GestureDetector(
          onTap: onAddChats,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image(
                  image: AssetImage('assets/images/chat_gradient_icon.png'),
                  width: 35,
                  height: 35,
                ),
                SizedBox(width: 10),
                Text(
                  'addChats'.tr(),
                  style: AppFontStyles.headerMediumStyle,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
