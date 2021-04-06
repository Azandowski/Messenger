import 'package:flutter/material.dart';

import '../chatControlPanel/cubit/panel_bloc_cubit.dart';
import '../chatControlPanel/presentation/chatControlPanel.dart';
import 'send_message_text_field.dart';

class SendMessageRow extends StatelessWidget {
  const SendMessageRow({
    Key key,
    @required this.widget,
    @required PanelBlocCubit panelBloc,
  }) : _panelBloc = panelBloc, super(key: key);

  final ChatControlPanel widget;
  final PanelBlocCubit _panelBloc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.emoji_emotions,
          color: Colors.grey,
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
