import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:easy_localization/easy_localization.dart';

class UnavailableFeatureDialog {
  static void show (BuildContext context) {
    showDialog(
      context: context, 
      builder: (context) => DialogsView(
        title: 'function_unavailable'.tr(),
        description: 'we_will_add_soon'.tr(),
        actionButton: [
          DialogActionButton(
            buttonStyle: DialogActionButtonStyle.cancel,
            title: 'ready'.tr(),
            onPress: () {
              Navigator.of(context).pop();
            }
          )
        ],
      )
    );
  }
}