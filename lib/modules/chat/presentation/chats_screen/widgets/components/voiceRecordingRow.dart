import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chatControlPanel/bloc/voice_record_bloc.dart';

import '../../../../../../app/appTheme.dart';

class VoiceRecordingRow extends StatefulWidget {
  final VoiceRecordBloc voiceRecordBloc;
  final Function onCancel;

  const VoiceRecordingRow({Key key,@required this.voiceRecordBloc, @required this.onCancel}) : super(key: key);
  @override
  _VoiceRecordingRowState createState() => _VoiceRecordingRowState();
}

class _VoiceRecordingRowState extends State<VoiceRecordingRow> with TickerProviderStateMixin{

  AnimationController animationController;
  Animation<double> _opacityAnimation;
  
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this,
     );
     _opacityAnimation = CurvedAnimation(parent: animationController, curve: Curves.easeInOutCubic);
     animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = widget.voiceRecordBloc.state;
    return Padding(
      padding: state is VoiceRecording && state.isHold ? EdgeInsets.zero : EdgeInsets.all(9.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0,9.0,9.0,9.0,),
            child: FadeTransition(
              opacity:_opacityAnimation,
              child: ClipOval(
                child: Container(
                  color: AppColors.redDeleteColor,
                  width: 12,
                  height: 12,
                ),
              ),
            ),
          ),
          Text('00:30'),
          if(state is VoiceRecording && state.isHold)...
            [
              SizedBox(width: MediaQuery.of(context).size.width/2-128,),
              TextButton(
                child: Text('Отмена',style: AppFontStyles.black16,),
                onPressed: widget.onCancel,
              ),
          ]
        ],
      ),
    );
  }
}