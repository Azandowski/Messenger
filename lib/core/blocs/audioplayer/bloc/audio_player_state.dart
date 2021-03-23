part of 'audio_player_bloc.dart';

enum VoicePlayerState {
  empty,
  playing,
  paused,
}

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = VoicePlayerState.empty,
    this.player,
    this.id = '',
  });

  const AuthenticationState.empty(player) : this._(player: player);

  const AuthenticationState.playing(String id)
      : this._(status: VoicePlayerState.playing, id: id);

  const AuthenticationState.paused()
      : this._(status: VoicePlayerState.paused);

  final VoicePlayerState status;
  final FlutterSoundPlayer player;
  final String id;

  @override
  List<Object> get props => [status, player, id];
}


abstract class AudioPlayerState extends Equatable {
  final FlutterSoundPlayer player;
  final VoicePlayerState playerState;
  final String uniqueId;

  AudioPlayerState({
    @required this.player,
    @required this.playerState,
    @required this.uniqueId,
  });
  
  @override
  List<Object> get props => [player,playerState,uniqueId];
}

class AudioPlayerInitial extends AudioPlayerState {
  final FlutterSoundPlayer player;
  final VoicePlayerState playerState;
  final String uniqueId;

  AudioPlayerInitial({
    @required this.player,
    @required this.playerState,
    @required this.uniqueId,
  }) : super(player: player, playerState: playerState, uniqueId: uniqueId);

  @override
  List<Object> get props => [player,playerState,uniqueId];
}
