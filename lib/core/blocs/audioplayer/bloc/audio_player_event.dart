part of 'audio_player_bloc.dart';

abstract class AudioPlayerEvent extends Equatable {
  const AudioPlayerEvent();

  @override
  List<Object> get props => [];
}

class PlayRemote extends AudioPlayerEvent {
  final String remoteURL;

  PlayRemote(this.remoteURL);
}

class PlayLocalPlayer extends AudioPlayerEvent {
  final String path;

  PlayLocalPlayer({
    @required this.path
  });
}

class ResetPlayer extends AudioPlayerEvent {}

class ShowPlayer extends AudioPlayerEvent {}

class StopPlayer extends AudioPlayerEvent {}

class StartResumeStop extends AudioPlayerEvent {
  final String path;

  StartResumeStop({
    @required this.path
  });
}

class HidePlayer extends AudioPlayerEvent {}