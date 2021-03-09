import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/icon_text_button.dart';

import '../../../../../app/appTheme.dart';
import '../../../../../core/widgets/independent/small_widgets/photo_picker_view.dart';
import '../../../../../core/widgets/independent/textfields/customTextField.dart';

class CreateCategoryHeader extends StatelessWidget {
  
  final ImageProvider imageProvider;
  final Function(File) selectImage;
  final TextEditingController nameController;
  final Function onAddChats;

  const CreateCategoryHeader({
    @required this.imageProvider, 
    @required this.selectImage,
    @required this.nameController,
    @required this.onAddChats,
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
          labelText: 'Название категории',
        ),
        IconTextButton(
          imageAssetPath: 'assets/images/chat_gradient_icon.png',
          onPress: onAddChats,
          title: 'Добавить чаты',
        )
      ],
    );
  }
}