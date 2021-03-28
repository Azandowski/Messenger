import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/blocs/audioplayer/bloc/audio_player_bloc.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/file_media.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/message_cell/play_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'music_progress_indicator.dart';

class AudioPlayerElement extends StatelessWidget {

  const AudioPlayerElement({Key key, @required this.file, @required this.audioPlayerBloc, @required this.isMine, @required this.message}) : super(key: key);
  final bool isMine;
  final Message message;
  final FileMedia file;
  final AudioPlayerBloc audioPlayerBloc;

  @override
  Widget build(BuildContext context) {
    final isSending = message.messageStatus == MessageStatus.sending;
    return isSending ? SendingAudioElement(message: message,) : BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
      builder: (context, state) {
        var maxDurationInDate = DateTime.fromMillisecondsSinceEpoch(
            file.maxDuration.inMilliseconds,
            isUtc: true);
        var maxDuration = DateFormat.ms().format(maxDurationInDate);
        return Row(
          children: [
            Container(
              child: state.id == file.url ? 
              StreamBuilder<PlaybackDisposition>(
              stream: BlocProvider.of<AudioPlayerBloc>(context).playerStream,
              initialData: PlaybackDisposition(duration: Duration(seconds: 1), position: Duration(seconds: 0)),
              builder: (context, snapshot) {
                var timeNow;
                var value;
                if(state.id == file.url){
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
                }else{
                  value = 0.0;
                  timeNow = '00:00';
                }
                return Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PlayButton(
                          file: file, state: state,
                          onTap: (){
                            audioPlayerBloc.add(StartResumeStop(path: file.url));
                          },
                        ),
                        SizedBox(width: 4,),
                        MusicProgressIndicator(value: value, isMine: isMine),
                        SizedBox(width: 8,),
                        Text(timeNow + ' / ', style: TextStyle(
                          color: isMine ? AppColors.greyColor : Colors.black26,
                          fontSize: 10,
                        ),),
                        Text(maxDuration, style: TextStyle(
                          color: isMine ? Colors.white : Colors.black87,
                          fontSize: 10,
                        )),
                      ],
                    ),
                  ),
                );
              }) : 
              Expanded(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PlayButton(
                        file: file, state: state,
                        onTap: (){
                          audioPlayerBloc.add(StartResumeStop(path: file.url));
                        },
                      ),
                      SizedBox(width: 4,),
                      MusicProgressIndicator(value: 0.0, isMine: isMine),
                      SizedBox(width: 8,),
                      Text('00:00' + ' / ', style: TextStyle(
                        color: isMine ? AppColors.greyColor : Colors.black26,
                        fontSize: 10,
                      ),),
                      Text(maxDuration, style: TextStyle(
                        color: isMine ? Colors.white : Colors.black87,
                        fontSize: 10,
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SendingAudioElement extends StatelessWidget {
  final Message message;

  const SendingAudioElement({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: message.uploadController?.stream,
      builder: (context, progress) {
        var percent = progress?.data ?? 0.0;
        return Container(
          child: Row(
            children: [
              ClipOval(
                child: Container(
                  child: CircularPercentIndicator(
                    percent: percent,
                    radius: 45,
                    progressColor: AppColors.successGreenColor,
                    backgroundColor: Colors.white,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      (percent * 100).floor().toString() + '%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    fillColor: AppColors.indicatorColor,
                  ),
                ),
              ),
              SizedBox(width: 4,),
              MusicProgressIndicator(value: 0.0, isMine: true),
              SizedBox(width: 4,),
              Text('Отправка',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ))
            ],
          ),
        );
      }
    );
  }
}