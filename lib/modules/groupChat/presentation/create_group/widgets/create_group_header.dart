import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../app/appTheme.dart';
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
          labelText: 'Название группы',
          customPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
        ),
        CustomTextField(
          textCtr: descriptionController,
          labelText: 'Описание (необязательно)',
          customPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
        ),
        GestureDetector(
          onTap: onAddContacts,
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
                  'Добавить контакты',
                  style: AppFontStyles.headerMediumStyle,
                )
              ],
            ),
          ),
        ),],
    );
  }
}