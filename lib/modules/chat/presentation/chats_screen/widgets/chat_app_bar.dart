import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_view_model.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/page/chat_detail_page.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chatHeading.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chat_screen_actions.dart';
import 'package:messenger_mobile/modules/chat/presentation/time_picker/time_picker_screen.dart';
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget{
  const ChatAppBar({
    Key key,
    @required this.chatViewModel,
    @required this.appBar,
    @required NavigatorState navigator,
    @required this.delegate,
    @required this.widget,
  }) : _navigator = navigator, super(key: key);

  final ChatViewModel chatViewModel;
  final NavigatorState _navigator;
  final ChatScreen widget;
  final AppBar appBar;
  final TimePickerDelegate delegate;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0.0,
      title: ChatHeading(
        title: chatViewModel.title ?? '',
        description: chatViewModel.description ?? '',
        avatarURL: chatViewModel.imageURL,
        onTap: () {
          _navigator.push(ChatDetailPage.route(widget.chatEntity.chatId));
        }
      ),
      actions: [
        ChatScreenActions(timePickerDelegate: delegate,)
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);

}
