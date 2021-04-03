
import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/utils/unavailable_dialog.dart';

import '../../../../../app/appTheme.dart';
import '../../../../../app/application.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_action_button.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_params.dart';
import '../../../../../core/widgets/independent/dialogs/dialogs.dart';
import '../../../../../locator.dart';
import '../../../../category/domain/entities/chat_entity.dart';
import '../../../../chats/presentation/pages/chats_search_screen.dart';
import '../../chat_details/page/chat_detail_page.dart';
import '../../chat_details/page/chat_detail_screen.dart';
import '../../time_picker/time_picker_screen.dart';
import 'appBars/chat_app_bar.dart';


class ChatScreenActions extends StatelessWidget {
  
  NavigatorState get _navigator => sl<Application>().navKey.currentState;
  
  final TimePickerDelegate timePickerDelegate;
  final ChatEntity chatEntity;
  final bool isSecretModeOn;
  final Function(ChatAppBarActions) onTapChatAction;

  const ChatScreenActions({
    @required this.onTapChatAction,
    this.timePickerDelegate,
    this.chatEntity,
    this.isSecretModeOn = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.video_call, 
            color: AppColors.indicatorColor,
          ), 
          onPressed: () {
            UnavailableFeatureDialog.show(context);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.call,
            color: AppColors.indicatorColor,
          ),
          onPressed: () {
            UnavailableFeatureDialog.show(context);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert_rounded,
            color: AppColors.indicatorColor,
          ),
          onPressed: () {
            showDialog(context: context,builder: (_) {
              return DialogsView( 
                dialogViewType: DialogViewType.actionSheet,
                actionButton: [
                  DialogActionButton(
                    title: chatEntity.isPrivate ? 'Данные профиля' : 'Подробнее', 
                    iconData: Icons.person,
                    buttonStyle: DialogActionButtonStyle.black,
                    onPress: () {
                      _navigator.push(ChatDetailPage.route(
                        chatEntity.chatId,
                        ProfileMode.chat
                      ));
                    }
                  ),
                  DialogActionButton(
                    title: 'Поиск', 
                    iconData: Icons.search,
                    buttonStyle: DialogActionButtonStyle.black,
                    onPress: () {
                      _navigator.push(ChatsSearchScreen.route(chatEntity: chatEntity));
                    }
                  ),
                  DialogActionButton(
                    title: (isSecretModeOn ?? false) ? 'Выключить таймер сгорания' : 'Включить таймер сгорания', 
                    iconData: Icons.timer,
                    buttonStyle: DialogActionButtonStyle.dangerous,
                    onPress: () {
                      onTapChatAction(ChatAppBarActions.onOffSecretMode);
                      Navigator.of(context).pop();
                      // _navigator.push(TimePickerScreen.route(timePickerDelegate));
                    }
                  ),
                ],
              );
            });
          },
        )
      ],
    );
  }
}


