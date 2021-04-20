import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:messenger_mobile/core/blocs/audioplayer/bloc/audio_player_bloc.dart';

import '../../../../../../app/appTheme.dart';
import '../../pages/chat_screen_import.dart';
import '../chatControlPanel/bloc/voice_record_bloc.dart';

class VoiceRecordingRow extends StatefulWidget {
  final VoiceRecordBloc voiceRecordBloc;
  final Function onCancel;
  final AudioPlayerBloc audioPlayerBloc;

  const VoiceRecordingRow({Key key,@required this.voiceRecordBloc, @required this.onCancel, @required this.audioPlayerBloc}) : super(key: key);
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

    final List<Widget> recordRow = [
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
      StreamBuilder<RecordingDisposition>(
        stream: widget.voiceRecordBloc.recordStream,
        initialData: RecordingDisposition(Duration(seconds: 0), 0),
        builder: (context, snapshot) {
          var date = DateTime.fromMillisecondsSinceEpoch(
            snapshot.data.duration.inMilliseconds,
            isUtc: true);
          var timeNow = DateFormat.ms().format(date);
          return Container(
            width: 60,
            child: Text(timeNow));
        }
      ),
      if(state is VoiceRecording && state.isHold)...
        [
          SizedBox(width: MediaQuery.of(context).size.width/2-144,),
          TextButton(
            child: Text(
              'cancel'.tr(), 
              style: AppFontStyles.black16
            ),
            onPressed: widget.onCancel,
          ),
        ],
    ];


    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
      builder: (context, otherState) {
        return Padding(
          padding: state is VoiceRecording && state.isHold ? EdgeInsets.zero : EdgeInsets.symmetric(vertical: 9.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: state is VoiceRecordingEndWillSend ? [
              GestureDetector(
                onTap: widget.onCancel,
                child: Icon(
                  Icons.delete,
                ),
              ),
              SizedBox(width: 4,),
              StreamBuilder<PlaybackDisposition>(
                stream: widget.audioPlayerBloc.playerStream,
                initialData: PlaybackDisposition(duration: Duration(seconds: 1), position: Duration(seconds: 0)),
                builder: (context, snapshot) {
                  var value = 0.0;
                  var timeNow = '00:00';
                  if (otherState.id == state.path) {
                    var maxDuration = snapshot.data.duration.inSeconds.toDouble();
                    var sliderCurrentPosition = min(snapshot.data.position.inSeconds.toDouble(), maxDuration);
                    if (sliderCurrentPosition < 0.0) {
                      sliderCurrentPosition = 0.0;
                    }
                    value = sliderCurrentPosition / maxDuration;
                    var date = DateTime.fromMillisecondsSinceEpoch(
                      snapshot.data.position.inMilliseconds,
                      isUtc: true);
                    timeNow = DateFormat.ms().format(date);
                  }
                  
                  return Expanded(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: (){
                              widget.audioPlayerBloc.add(StartResumeStop(path: state.path));
                            },
                            child: Icon(
                            (otherState.status == VoicePlayerState.playing && otherState.id == state.path) ? Icons.pause : Icons.play_arrow,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 4,),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              height: 5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                child: LinearProgressIndicator(
                                  value: value,
                                  backgroundColor: Colors.black12,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.indicatorColor),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8,),
                          Text(timeNow),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ] : recordRow,
          ),
        );
      },
    );
  }
}
