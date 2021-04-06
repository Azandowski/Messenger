
import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/blocs/audioplayer/bloc/audio_player_bloc.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/file_media.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({
    Key key,
    @required this.file,
    @required this.onTap,
    @required this.state,
  }) : super(key: key);

  final FileMedia file;
  final Function onTap;
  final AudioPlayerState state;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: AppColors.successGreenColor,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              (state.status == VoicePlayerState.playing && state.id == file.url) ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
          ), 
          onTap: onTap,
        ),
      ),
    );
  }
}