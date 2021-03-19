part of 'voice_record_bloc.dart';

abstract class VoiceRecordEvent extends Equatable {
  const VoiceRecordEvent();

  @override
  List<Object> get props => [];
}

class VoiceStartRecording extends VoiceRecordEvent {}

class VoiceHoldRecoriding extends VoiceRecordEvent {}

class VoiceSentImmideately extends VoiceRecordEvent {}

class VoiceDismissedRecording extends VoiceRecordEvent {}