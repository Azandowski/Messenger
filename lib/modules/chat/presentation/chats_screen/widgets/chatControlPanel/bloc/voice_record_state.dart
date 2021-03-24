part of 'voice_record_bloc.dart';

abstract class VoiceRecordState extends Equatable {

  final String path;
  const VoiceRecordState({
    @required this.path,
  });
  
  @override
  List<Object> get props => [path];
}

class VoiceRecordEmpty extends VoiceRecordState {
  final String path;

  const VoiceRecordEmpty({
    @required this.path,
  }) : super(path: path);
  
  @override
  List<Object> get props => [path];
}

class VoiceRecording extends VoiceRecordState {
  final isHold;
  final String path;

  VoiceRecording({
    @required this.isHold,
    @required this.path,
  }) : super(path: path);

  @override
  List<Object> get props => [isHold, path];
}



class VoiceRecordingEndWillSend extends VoiceRecordState {
  final String path;

  const VoiceRecordingEndWillSend({
    @required this.path,
  }) : super(path: path);
  
  @override
  List<Object> get props => [path];
}


