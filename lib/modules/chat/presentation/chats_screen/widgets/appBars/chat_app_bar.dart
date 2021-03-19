import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import '../../../../../category/data/models/chat_view_model.dart';
import '../../../chat_details/page/chat_detail_page.dart';
import '../../pages/chat_screen.dart';
import '../chatHeading.dart';
import '../chat_screen_actions.dart';

enum ChatAppBarActions { onOffSecretMode }

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget{
  ChatAppBar({
    Key key,
    @required this.onTapChatAction,
    @required this.chatViewModel,
    @required this.appBar,
    @required NavigatorState navigator,
    @required this.widget,
    this.isSecretModeOn = false
  }) : _navigator = navigator, super(key: key);

  final ChatViewModel chatViewModel;
  final NavigatorState _navigator;
  final ChatScreen widget;
  final AppBar appBar;
  final bool isSecretModeOn;
  final Function(ChatAppBarActions) onTapChatAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0.0,
      title: ChatHeading(
        title: chatViewModel.title ?? '',
        description: chatViewModel.description ?? '',
        avatarURL: chatViewModel.imageURL,
        onTap: () async {
          var newPermissions = await _navigator.push(ChatDetailPage.route(widget.chatEntity));
          context.read<ChatBloc>().add(PermissionsUpdated(
            newPermissions: newPermissions
          ));
        }
      ),
      actions: [
        ChatScreenActions(
          chatEntity: chatViewModel.entity,
          isSecretModeOn: isSecretModeOn,
          onTapChatAction: onTapChatAction
        )
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
