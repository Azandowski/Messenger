import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../pages/chat_screen_import.dart';

part 'voice_record_event.dart';
part 'voice_record_state.dart';

class VoiceRecordBloc extends Bloc<VoiceRecordEvent, VoiceRecordState> {
  VoiceRecordBloc() : super(VoiceRecordEmpty());

  @override
  Stream<VoiceRecordState> mapEventToState(
    VoiceRecordEvent event,
  ) async* {
    if(event is VoiceStartRecording){
      yield VoiceRecording(isHold: false);
    }else if(event is VoiceHoldRecoriding){
      yield VoiceRecording(isHold: true);
    }else if(event is VoiceDismissedRecording){
      yield VoiceRecordEmpty();
    }
  }
}
