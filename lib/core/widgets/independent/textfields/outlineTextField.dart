import 'package:flutter/material.dart';

import '../../../../app/appTheme.dart';

class OutlineTextField extends StatelessWidget {
  const OutlineTextField({
    Key key,
    @required this.focusNode,
    @required this.textEditingController,
    @required this.width,
    @required this.height,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: textEditingController,
      keyboardType: TextInputType.phone,
      cursorColor: AppColors.accentBlueColor,
      decoration: InputDecoration(
          prefix: Text('+', style: AppFontStyles.blackMediumStyle),
          contentPadding: EdgeInsets.symmetric(
              horizontal: width / (360 / 16), vertical: height / (724 / 18)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: AppColors.indicatorColor,
                width: 1,
              )),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: AppColors.greyColor,
                width: 1,
              )),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: AppColors.indicatorColor,
                width: 1,
              )),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: AppColors.indicatorColor,
                width: 1,
              )),
          labelText: 'Номер телефона',
          labelStyle: AppFontStyles.blueSmallStyle),
    );
  }
}
