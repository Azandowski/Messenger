import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../app/appTheme.dart';
import '../chatControlPanel/cubit/panel_bloc_cubit.dart';
import '../chatControlPanel/presentation/chatControlPanel.dart';

class SendMessageTextField extends StatelessWidget {
  const SendMessageTextField({
    Key key,
    @required this.widget,
    @required PanelBlocCubit panelBloc,
    @required this.textFieldFocusNode
  }) : _panelBloc = panelBloc, super(key: key);

  final ChatControlPanel widget;
  final PanelBlocCubit _panelBloc;
  final FocusNode textFieldFocusNode;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: widget.messageTextController,
        textCapitalization: TextCapitalization.sentences,
        focusNode: textFieldFocusNode,
        onChanged: (String text) => _panelBloc.updateText(text),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
          horizontal: widget.width / (360 / 16), vertical: widget.height / (724 / 18)),
        hintText: 'message'.tr(),
        labelStyle: AppFontStyles.blueSmallStyle)
      ),
    );
  }
}
