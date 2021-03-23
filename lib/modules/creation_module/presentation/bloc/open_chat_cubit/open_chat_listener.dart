import 'package:messenger_mobile/core/utils/snackbar_util.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/open_chat_cubit/open_chat_cubit.dart';

class OpenChatListener {
  void handleStateUpdate (BuildContext context, OpenChatState state) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (state is OpenChatLoading) {
      SnackUtil.showLoading(context: context);
    } else if (state is OpenChatError){
      SnackUtil.showError(context: context, message: state.message);
    } else if (state is OpenChatDone) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChatScreen(
          chatEntity: state.newChat
        )),
      );
    }
  }  
}