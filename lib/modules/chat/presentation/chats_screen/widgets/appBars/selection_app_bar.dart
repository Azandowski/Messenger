import 'package:flutter/material.dart';
import '../../../../../../app/appTheme.dart';
import '../../../../../category/data/models/chat_view_model.dart';
import '../../cubit/chat_todo_cubit.dart';
import '../../pages/chat_screen.dart';
class SelectionAppBar extends StatelessWidget implements PreferredSizeWidget{
  const SelectionAppBar({
    Key key,
    @required this.chatViewModel,
    @required this.appBar,
    @required this.chatTodoCubit,
    @required this.widget,
  }) : super(key: key);

  final ChatViewModel chatViewModel;
  final ChatScreen widget;
  final AppBar appBar;
  final ChatTodoCubit chatTodoCubit;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0.0,
      title:RichText(
        text: TextSpan(
          text: 'Выбрано: ',
          style: AppFontStyles.black16,
          children: <TextSpan>[
            TextSpan(text: chatTodoCubit.state.selectedMessages.length.toString(), style: AppFontStyles.purple15),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextButton(onPressed: (){
            chatTodoCubit.disableSelectionMode();
          }, 
          child: Text('Отменить',
            style: AppFontStyles.purple15,
          ),
          
      ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);

}
