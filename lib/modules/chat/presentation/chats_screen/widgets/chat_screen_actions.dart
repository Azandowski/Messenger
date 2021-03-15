
import 'package:flutter/material.dart';
import '../../../../../app/appTheme.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_action_button.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_params.dart';
import '../../../../../core/widgets/independent/dialogs/dialogs.dart';
import '../../chat_details/page/chat_detail_page.dart';
import '../../time_picker/time_picker_screen.dart';

import '../../../../../main.dart';

class ChatScreenActions extends StatelessWidget {
  
  NavigatorState get _navigator => navigatorKey.currentState;
  
  final TimePickerDelegate timePickerDelegate;
  final int chatID;

  const ChatScreenActions({
    this.timePickerDelegate,
    this.chatID,
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
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.call,
            color: AppColors.indicatorColor,
          ),
          onPressed: () {
          
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
                    title: 'Данные профиля', 
                    iconData: Icons.person,
                    buttonStyle: DialogActionButtonStyle.black,
                    onPress: () {
                      _navigator.push(ChatDetailPage.route(chatID));
                    }
                  ),
                  DialogActionButton(
                    title: 'Таймер сгорания сообщений', 
                    iconData: Icons.timer,
                    buttonStyle: DialogActionButtonStyle.dangerous,
                    onPress: () {
                      _navigator.push(TimePickerScreen.route(timePickerDelegate));
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


