import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/appTheme.dart';
import '../../../../core/widgets/independent/buttons/gradient_main_button.dart';
import '../bloc/index.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class PinCodePage extends StatefulWidget {
  @override
  _PinCodePageState createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  int timer = 30;

  bool error = false;

  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (time) {
      if (mounted) {
        setState(() {
          if (timer != 0) {
            timer--;
          } else {
            time.cancel();
          }
        });
      }
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      var phoneNumber = (state as CodeState).codeEntity.phone;
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Введите полученный код',
                style: AppFontStyles.headingBlackStyle),
            SizedBox(height: 8),
            Text('Код отправлен на $phoneNumber',
                style: AppFontStyles.greyPhoneStyle),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                child: PinInputTextField(
                  onSubmit: (value) => print(value),
                  pinLength: 4,
                  focusNode: _pinPutFocusNode,
                  controller: _pinPutController,
                  decoration: BoxLooseDecoration(
                    gapSpace: 10,
                    radius: Radius.circular(10),
                    strokeColorBuilder: PinListenColorBuilder(
                        Color(0xff8F4BCF), Color(0xffBDBDBD)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Center(
                child: timer > 0
                    ? Text('Получить код повторно через: $timer сек',
                        style: AppFontStyles.greyPhoneStyle)
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            var authBloc =
                                BlocProvider.of<AuthenticationBloc>(context);
                            authBloc.add(CreateCodeEvent(phoneNumber));
                            timer = 30;
                            _startTimer();
                            _pinPutController.clear();
                          });
                        },
                        child: Text('Получить код повторно',
                            style: AppFontStyles.greyPhoneStyle),
                      )),
            SizedBox(
              height: height * 0.1,
            ),
            ActionButton(
              text: 'Подтвердить',
              onTap: () {
                print(_pinPutController.value.text);
                if (_pinPutController.value.text != null &&
                    _pinPutController.value.text != '') {
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                    'dalbayeb',
                    style: AppFontStyles.headingBlackStyle,
                  )));
                }
                // var authBloc = BlocProvider.of<AuthenticationBloc>(context);
                // authBloc.add(CreateCodeEvent(_textEditingController.text));
              },
            ),
          ],
        ),
      );
    });
  }
}
