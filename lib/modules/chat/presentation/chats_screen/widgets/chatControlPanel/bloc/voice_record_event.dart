part of 'voice_record_bloc.dart';

abstract class VoiceRecordEvent extends Equatable {
  const VoiceRecordEvent();

  @override
  List<Object> get props => [];
}

class VoiceStartRecording extends VoiceRecordEvent {}

class VoiceHoldRecoriding extends VoiceRecordEvent {}

class VoiceSentImmideately extends VoiceRecordEvent {}

class VoiceStopRecording extends VoiceRecordEvent {}

class VoiceStopHolding extends VoiceRecordEvent {}

class VoicePauseResume extends VoiceRecordEvent {}

class VoicePlayerFinished extends VoiceRecordEvent {}

class VoiceStartResumeStop extends VoiceRecordEvent{
  final VoicePlayerState playerState;

  VoiceStartResumeStop({
    @required this.playerState
  });

  @override
  List<Object> get props => [playerState];
}

class VoiceBlocDispose extends VoiceRecordEvent {}

class VoiceSendAudio extends VoiceRecordEvent{}


