import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/social_media/domain/entities/social_media.dart';
import '../helpers/ui_helper.dart';

class SocialMediaItem extends StatelessWidget {
  final SocialMediaType socialMediaType;
  final TextEditingController textEditingController;

  SocialMediaItem({
    @required this.socialMediaType,
    @required this.textEditingController
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: textEditingController,
        cursorColor: AppColors.indicatorColor,
        decoration: InputDecoration(
          filled: true,
          prefixIcon: Container(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              socialMediaType.assetImagePath,
              width: 16, height: 16,
              fit: BoxFit.cover,
            ),
          ),
          labelText: socialMediaType.helperText,
          labelStyle: TextStyle(color: Colors.grey)
        ),
        validator: (text) {
          if (socialMediaType != SocialMediaType.whatsapp) {
            if (text != '' && !isWebiteLinkValid(text)) {
              return socialMediaType.errorText;
            }
          } else {
            if (text != '' && !isPhoneNumberValid(text)) {
              return socialMediaType.errorText;
            }
          }

          return null;
        },
      )
    );
  }

  bool isPhoneNumberValid (String value) {
    String pattern = r'(^\+?[0-9]{3}-?[0-9]{6,12}$)';
    RegExp regExp = new RegExp(pattern);

    return regExp.hasMatch(value);
  }

  bool isWebiteLinkValid (String value) {
    var pattern = r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    RegExp regExp = new RegExp(pattern, caseSensitive: false);

    return regExp.hasMatch(value);
  }
}