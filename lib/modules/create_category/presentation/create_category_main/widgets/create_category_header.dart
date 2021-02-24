import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/photo_picker_view.dart';
import 'package:messenger_mobile/core/widgets/independent/textfields/customTextField.dart';

class CreateCategoryHeader extends StatelessWidget {
  
  final ImageProvider imageProvider;
  final Function(File) selectImage;

  const CreateCategoryHeader({
    @required this.imageProvider, 
    @required this.selectImage,
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
          labelText: 'Название категории',
        ),
        Container(
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
                'Добавить чаты',
                style: AppFontStyles.mainStyle,
              )
            ],
          ),
        )
      ],
    );
  }
}