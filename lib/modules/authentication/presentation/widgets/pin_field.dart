import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import '../pages/type_code_page.dart/pages/type_code_page.dart';
import '../pages/type_phone_page/cubit/typephone_cubit.dart';

class PinField extends StatelessWidget {
  const PinField({
    Key key,
    @required FocusNode pinPutFocusNode,
    @required this.phoneCubit,
    @required this.onSubmit,
    @required this.widget,
    @required TextEditingController pinPutController,
  })  : _pinPutFocusNode = pinPutFocusNode,
        _pinPutController = pinPutController,
        super(key: key);
  final Function(String) onSubmit;
  final FocusNode _pinPutFocusNode;
  final TypephoneCubit phoneCubit;
  final TypeCodePage widget;
  final TextEditingController _pinPutController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        child: PinInputTextField(
          onSubmit: onSubmit,
          pinLength: 4,
          focusNode: _pinPutFocusNode,
          controller: _pinPutController,
          decoration: BoxLooseDecoration(
            gapSpace: 10,
            radius: Radius.circular(10),
            strokeColorBuilder:
                PinListenColorBuilder(Color(0xff8F4BCF), Color(0xffBDBDBD)),
          ),
        ),
      ),
    );
  }
}
