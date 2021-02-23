import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/screens/offert_screen.dart';

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
