import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/bloc/chat_bloc.dart';

class BottomPin extends StatelessWidget {
  const BottomPin({
    @required this.state,
    @required this.onPress,
    Key key,
  });

  final ChatState state;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.indicatorColor,
      child: Container(
        child: Center(
          child: (state.unreadCount != null && state.unreadCount != 0) ? 
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Center(
                child: Text(
                  '${state.unreadCount}',
                  style: TextStyle(color: AppColors.accentBlueColor),
                ),
              ),
            ) : Icon(
              Icons.arrow_downward, color: Colors.white
            )
        )
      ),
      onPressed: onPress
    );
  }
}

