part of 'audio_player_bloc.dart';

enum VoicePlayerState {
  empty,
  playing,
  paused,
}

class AudioPlayerState extends Equatable {
  const AudioPlayerState._({
    this.status = VoicePlayerState.empty,
    this.id = '',
  });

  AudioPlayerState.empty() : this._();

  const AudioPlayerState.playing(String id,)
      : this._(status: VoicePlayerState.playing, id: id,);

  const AudioPlayerState.paused(String id)
      : this._(status: VoicePlayerState.paused, id: id);

  final VoicePlayerState status;
  final String id;

  @override
  List<Object> get props => [status, id];
}


// abstract class AudioPlayerState extends Equatable {
//   final FlutterSoundPlayer player;
//   final VoicePlayerState playerState;
//   final String uniqueId;

//   AudioPlayerState({
//     @required this.player,
//     @required this.playerState,
//     @required this.uniqueId,
//   });
  
//   @override
//   List<Object> get props => [player,playerState,uniqueId];
// }

// class AudioPlayerInitial extends AudioPlayerState {
//   final FlutterSoundPlayer player;
//   final VoicePlayerState playerState;
//   final String uniqueId;

//   AudioPlayerInitial({
//     @required this.player,
//     @required this.playerState,
//     @required this.uniqueId,
//   }) : super(player: player, playerState: playerState, uniqueId: uniqueId);

//   @override
//   List<Object> get props => [player,playerState,uniqueId];
// }
