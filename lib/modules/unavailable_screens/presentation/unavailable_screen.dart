import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:easy_localization/easy_localization.dart';

class UnavailableScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/unavailable_banner.png',
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 16),
                Text(
                  'dear_users'.tr(),
                  style: AppFontStyles.headingBlackStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'unavailable_function_hint'.tr(),
                  style: AppFontStyles.grey14w400,
                  textAlign: TextAlign.center,
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}