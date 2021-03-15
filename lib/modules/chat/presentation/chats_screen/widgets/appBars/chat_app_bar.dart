import 'package:flutter/material.dart';

import '../../../../../category/data/models/chat_view_model.dart';
import '../../../chat_details/page/chat_detail_page.dart';
import '../../../time_picker/time_picker_screen.dart';
import '../../pages/chat_screen.dart';
import '../chatHeading.dart';
import '../chat_screen_actions.dart';

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
          _navigator.push(ChatDetailPage.route(widget.chatEntity));
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
