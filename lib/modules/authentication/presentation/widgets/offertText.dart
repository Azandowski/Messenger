import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../app/appTheme.dart';
import '../../../../core/screens/offert_screen.dart';

class OffertTextWidget extends StatelessWidget {
  const OffertTextWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40, top: 20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: RichText(
            text: TextSpan(
                text: "you_agree_by_continuing".tr(),
                style: AppFontStyles.placeholderStyle,
                children: [
                  TextSpan(
                    text: " ${'handle_personal_info'.tr()}",
                    style: AppFontStyles.indicatorSmallStyle),
                ]),
            textAlign: TextAlign.start,
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => OffertView(type: OffertType.personalData,)));
      },
    );
  }
}
