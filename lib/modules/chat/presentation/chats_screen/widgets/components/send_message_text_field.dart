import 'package:flutter/material.dart';

import '../../../../../../app/appTheme.dart';
import '../chatControlPanel/chatControlPanel.dart';
import '../chatControlPanel/cubit/panel_bloc_cubit.dart';

class SendMessageTextField extends StatelessWidget {
  const SendMessageTextField({
    Key key,
    @required this.widget,
    @required PanelBlocCubit panelBloc,
  }) : _panelBloc = panelBloc, super(key: key);

  final ChatControlPanel widget;
  final PanelBlocCubit _panelBloc;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
      controller: widget.messageTextController,
      onChanged: (String text) => _panelBloc.updateText(text),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
        horizontal: widget.width / (360 / 16), vertical: widget.height / (724 / 18)),
      hintText: 'Сообщение',
      labelStyle: AppFontStyles.blueSmallStyle)),
    );
  }
}
