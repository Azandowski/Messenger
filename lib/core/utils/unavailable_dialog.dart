import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';

class UnavailableFeatureDialog {
  static void show (BuildContext context) {
    showDialog(
      context: context, 
      builder: (context) => DialogsView(
        title: 'Данная функция не доступна',
        description: 'В скором времени мы добавим это',
        actionButton: [
          DialogActionButton(
            buttonStyle: DialogActionButtonStyle.cancel,
            title: 'Готово',
            onPress: () {
              Navigator.of(context).pop();
            }
          )
        ],
      )
    );
  }
}