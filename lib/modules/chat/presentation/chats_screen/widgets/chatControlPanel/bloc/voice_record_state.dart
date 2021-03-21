part of 'voice_record_bloc.dart';

abstract class VoiceRecordState extends Equatable {
  const VoiceRecordState();
  
  @override
  List<Object> get props => [];
}

class VoiceRecordEmpty extends VoiceRecordState {}

class VoiceRecording extends VoiceRecordState {
  final isHold;

  VoiceRecording({
    @required this.isHold
  });

  @override
  List<Object> get props => [isHold];
}

enum VoicePlayerState {
  empty,
  playing,
  paused,
}

class VoiceRecordingEndWillSend extends VoiceRecordState {
  final VoicePlayerState playerState;

  VoiceRecordingEndWillSend({
    @required this.playerState
  });

  @override
  List<Object> get props => [playerState];
}


