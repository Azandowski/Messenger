import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/open_chat_cubit/open_chat_cubit.dart';

class OpenChatListener {
  void handleStateUpdate (BuildContext context, OpenChatState state) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (state is OpenChatLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: LinearProgressIndicator(), 
          duration: Duration(days: 2),
        )
      );
    } else if (state is OpenChatError){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
        state.message
      )));
    } else if (state is OpenChatDone) {
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChatScreen(
          chatEntity: state.newChat
        )),
      );
    }
  }  
}