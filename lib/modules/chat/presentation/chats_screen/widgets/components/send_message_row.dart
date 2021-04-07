import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/chat/presentation/time_picker/time_picker_screen.dart';

import '../chatControlPanel/cubit/panel_bloc_cubit.dart';
import '../chatControlPanel/presentation/chatControlPanel.dart';
import 'send_message_text_field.dart';

class SendMessageRow extends StatelessWidget {
  const SendMessageRow({
    Key key,
    @required this.widget,
    @required PanelBlocCubit panelBloc,
    @required this.onTapLeadingIcon,
    @required this.currentTimeOptions
  }) : _panelBloc = panelBloc, super(key: key);

  final ChatControlPanel widget;
  final PanelBlocCubit _panelBloc;
  final TimeOptions currentTimeOptions;
  final Function onTapLeadingIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onTapLeadingIcon,
          child: currentTimeOptions == null ? Icon(
            Icons.emoji_emotions,
            color: Colors.grey,
          ) : Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.indicatorColor,
              borderRadius: BorderRadius.circular(15)
            ),
            child: Center(
              child: Text(
                currentTimeOptions.hint,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white
                ),
              )
            )
          ),
        ),
        SendMessageTextField(widget: widget, panelBloc: _panelBloc,),
        InkWell(
          onTap: () {
            _panelBloc.toggleBottomPanel();
          },
          child: Icon(
            Icons.attach_file,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
