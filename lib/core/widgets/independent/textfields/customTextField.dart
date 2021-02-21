import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';

class CustomTextField extends StatelessWidget {
  final IconData prefixIcon;
  final onChanged;
  final obscure;
  final textCtr;
  final String labelText;
  final headText;
  final int maxSymbols;
  final helperText;
  final Function(String) validator;
  final EdgeInsets customPadding;

  CustomTextField({ 
    this.prefixIcon, this.obscure, this.onChanged, this.textCtr,
    this.headText, this.helperText, this.maxSymbols,
    this.labelText, this.validator, this.customPadding
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: customPadding ?? const EdgeInsets.only(top: 35,left: 16,right: 16),
      child: Container(
        height: 80,
        child: TextFormField(
          textAlign: TextAlign.start,
          maxLength: maxSymbols ?? 100,
          controller: textCtr,
          cursorColor: AppColors.accentBlueColor,
          validator: validator,
          obscureText: obscure ?? false,
          decoration: new InputDecoration(
            errorStyle: TextStyle(color: Colors.red),
            suffixIcon: Icon(prefixIcon, color: Colors.black, size: 15,),
            suffixIconConstraints: BoxConstraints(maxHeight: 50),
            helperText: helperText ?? '',
            helperStyle: TextStyle(color: AppColors.accentBlueColor),
            labelStyle: TextStyle(color: AppColors.accentBlueColor),
            labelText: labelText ?? '',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.accentBlueColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.accentBlueColor),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.accentBlueColor),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          keyboardType: TextInputType.text,
          style: AppFontStyles.mainStyle,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
