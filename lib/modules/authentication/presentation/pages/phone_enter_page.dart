import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/widgets/independent/textfields/outlineTextField.dart';
import '../../../../app/appTheme.dart';
import '../../../../core/screens/offert_screen.dart';
import '../../../../core/widgets/independent/buttons/gradient_main_button.dart';

class PhoneEnterPage extends StatefulWidget {
  @override
  _PhoneEnterPageState createState() => _PhoneEnterPageState();
}

class _PhoneEnterPageState extends State<PhoneEnterPage> {
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {
        isFocused = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Введите номер телефона',
            style: AppFontStyles.headingBlackStyle,
          ),
          SizedBox(
            height: height * 0.05,
          ),
          OutlineTextField(
              focusNode: focusNode,
              textEditingController: textEditingController,
              width: width,
              height: height),
          OffertTextWidget(),
          ActionButton(
            text: 'Продолжить',
            onTap: () {},
          )
        ],
      ),
    );
  }
}

class OffertTextWidget extends StatelessWidget {
  const OffertTextWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40, top: 20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: RichText(
            text: TextSpan(
                text: "you_agree_by_continuing",
                style: AppFontStyles.paleStyle,
                children: [
                  TextSpan(
                      text: " ${'handle_personal_info'}",
                      style: AppFontStyles.indicatorSmallStyle),
                ]),
            textAlign: TextAlign.start,
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => OffertView()));
      },
    );
  }
}
