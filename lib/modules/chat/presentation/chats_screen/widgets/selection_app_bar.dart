import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_view_model.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/bloc/chat_bloc.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen.dart';
import 'package:messenger_mobile/modules/chat/presentation/time_picker/time_picker_screen.dart';
class SelectionAppBar extends StatelessWidget implements PreferredSizeWidget{
  const SelectionAppBar({
    Key key,
    @required this.chatViewModel,
    @required this.appBar,
    @required this.delegate,
    @required this.chatBloc,
    @required this.widget,
  }) : super(key: key);

  final ChatViewModel chatViewModel;
  final ChatScreen widget;
  final AppBar appBar;
  final ChatBloc chatBloc;
  final TimePickerDelegate delegate;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0.0,
      title:Text('Выбрано'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextButton(onPressed: (){
            chatBloc.add(DisableSelectMode());
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
