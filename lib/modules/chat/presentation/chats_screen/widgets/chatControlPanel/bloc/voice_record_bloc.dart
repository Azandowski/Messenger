import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:messenger_mobile/core/blocs/audioplayer/bloc/audio_player_bloc.dart';
import '../../../../../../../core/utils/feedbac_taptic_helper.dart';
import '../../../../../domain/usecases/params.dart';
import '../../../../chat_details/widgets/chat_media_block.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibrate/vibrate.dart';
import '../../../pages/chat_screen_import.dart';

part 'voice_record_event.dart';
part 'voice_record_state.dart';

class VoiceRecordBloc extends Bloc<VoiceRecordEvent, VoiceRecordState> {
  final ChatBloc chatBloc;
  final AudioPlayerBloc audioPlayerBloc;

  VoiceRecordBloc({
    @required this.chatBloc,
    @required this.audioPlayerBloc,
  }) : super(VoiceRecordEmpty(path: 'empty')){
    myRecorder = FlutterSoundRecorder();
    askPermission();
    init();
  }
  
  Codec _codec = Codec.aacMP4;

  FlutterSoundRecorder myRecorder;

  StreamSubscription<RecordingDisposition> _recorderSubscription;

  var _recoderController = StreamController<RecordingDisposition>.broadcast();
  Stream<RecordingDisposition> get recordStream =>_recoderController.stream;

  clear(){
    _recoderController.add(null);
  }

  dispose() {
    _recoderController.close();
  }

  @override
  Stream<VoiceRecordState> mapEventToState(
    VoiceRecordEvent event,
  ) async* {
    if(event is VoiceStartRecording){
      startRecorder();
      yield VoiceRecording(isHold: false, path: this.state.path);
    }else if(event is VoiceHoldRecoriding){
      yield VoiceRecording(isHold: true, path: this.state.path);
    }else if(event is VoiceStopRecording){
      stopRecorder();
      stopPlayer();
      yield VoiceRecordEmpty(path: this.state.path);
    }else if(event is VoiceStopHolding){
      FeedbackEngine.showFeedback(FeedbackType.success);
      stopRecorder();
      yield VoiceRecordingEndWillSend(path: this.state.path);
    }else if(event is VoiceSendAudio){
      chatBloc.add(MessageSend(
        fieldFiles: FieldFiles(
          fieldKey: MediaType.audio,
          files: [File(this.state.path)]
        ),
      ));
      FeedbackEngine.showFeedback(FeedbackType.success);
    }else if(event is VoiceBlocDispose){
      disposeBloc();
      this.close();
    }else if(event is VoiceChangePath){
      yield VoiceRecording(isHold: false, path: event.path);
    }
  }

   Future<void> init() async {
    await myRecorder.openAudioSession(
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeVoiceChat,
        device: AudioDevice.speaker);
    await myRecorder.setSubscriptionDuration(Duration(milliseconds: 10));
  }

  void disposeBloc(){ 
    if (myRecorder != null){
      myRecorder.closeAudioSession();
      myRecorder = null;
    }
    dispose();
  }

  void startRecorder() async {
    try {
      var path;
        var tempDir = await getTemporaryDirectory();
        path = '${tempDir.path}/flutter_sound${ext[_codec.index]}';

        await myRecorder.startRecorder(
          toFile: path,
          codec: _codec,
          bitRate: 32000,
          numChannels: 1,
          sampleRate: 32000,
        );

      _recorderSubscription = myRecorder.onProgress.listen((e) {
        _recoderController.sink.add(e);
      });

      this.add(VoiceChangePath(path));
        
    } on Exception catch (err) {
      print('startRecorder error: $err');
      stopRecorder();
      cancelRecorderSubscriptions();
    }
  }

  void stopRecorder() async {
    try {
      await myRecorder.stopRecorder();
      cancelRecorderSubscriptions();
    } on Exception catch (err) {
      print('stopRecorder error: $err');
    }
  }

  stopPlayer() async {
    audioPlayerBloc.add(StopPlayer());
  }

  void cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription.cancel();
      _recorderSubscription = null;
    }
  }

  void askPermission() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException(
          'Microphone permission not granted');
    }
  }
}
