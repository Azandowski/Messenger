import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:messenger_mobile/core/utils/feedbac_taptic_helper.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sembast/sembast.dart';
import 'package:vibrate/vibrate.dart';
import '../../../pages/chat_screen_import.dart';

part 'voice_record_event.dart';
part 'voice_record_state.dart';

class VoiceRecordBloc extends Bloc<VoiceRecordEvent, VoiceRecordState> {
  final ChatBloc chatBloc;

  VoiceRecordBloc({
    @required this.chatBloc,
  }) : super(VoiceRecordEmpty()){
    myRecorder = FlutterSoundRecorder();
    playerModule = FlutterSoundPlayer();
    askPermission();
    init();
  }
  
  Codec _codec = Codec.aacMP4;

  FlutterSoundRecorder myRecorder;

  FlutterSoundPlayer playerModule;

  var _path = '';

  StreamSubscription<RecordingDisposition> _recorderSubscription;
  StreamSubscription<PlaybackDisposition> _playerSubscription;

  var _recoderController = StreamController<RecordingDisposition>.broadcast();
  Stream<RecordingDisposition> get recordStream =>_recoderController.stream;

  var _playerController = StreamController<PlaybackDisposition>.broadcast();
  Stream<PlaybackDisposition> get playerStream => _playerController.stream;

  clear(){
    _recoderController.add(null);
  }

  dispose() {
    _recoderController.close();
    _playerController.close();
  }

  @override
  Stream<VoiceRecordState> mapEventToState(
    VoiceRecordEvent event,
  ) async* {
    if(event is VoiceStartRecording){
      startRecorder();
      yield VoiceRecording(isHold: false);
    }else if(event is VoiceHoldRecoriding){
      yield VoiceRecording(isHold: true);
    }else if(event is VoiceStopRecording){
      stopRecorder();
      stopPlayer();
      yield VoiceRecordEmpty();
    }else if(event is VoiceStopHolding){
      FeedbackEngine.showFeedback(FeedbackType.success);
      stopRecorder();
      yield VoiceRecordingEndWillSend(
        playerState: VoicePlayerState.empty,
      );
    }else if(event is VoiceStartResumeStop){
      yield* _mapPlayerStateToPlayerAction(event);
    }else if(event is VoicePlayerFinished){
      yield VoiceRecordingEndWillSend(playerState: VoicePlayerState.empty);
    }else if(event is VoiceSendAudio){
      chatBloc.add(MessageSend(
        fieldFiles: FieldFiles(
          fieldKey: FileKey.audio,
          files: [File(_path)]
        ),
      ));
      FeedbackEngine.showFeedback(FeedbackType.success);
    }else if(event is VoiceBlocDispose){
      disposeBloc();
      this.close();
    }
  }

   Future<void> init() async {
    await myRecorder.openAudioSession(
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeVoiceChat,
        device: AudioDevice.speaker);
    await _initializeExample(false);
  }

  Future<void> _initializeExample(bool withUI) async {

    await playerModule.closeAudioSession();

    await playerModule.openAudioSession(
        withUI: withUI,
        focus: AudioFocus.requestFocusAndStopOthers,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);
    await playerModule.setSubscriptionDuration(Duration(milliseconds: 10));
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

      _path = path;
        
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

  Future<void> startPlayer() async {
    try {
      String audioFilePath;
      var codec = _codec;
      audioFilePath = _path;
      //Duration toto  = await flutterSoundHelper.duration(audioFilePath);
      //print(toto.inMilliseconds);
      if (audioFilePath != null) {
        await playerModule.startPlayer(
          fromURI: audioFilePath,
          codec: codec,
          sampleRate: 32000,
          whenFinished: () {
            this.add(VoicePlayerFinished());
          }
        );
      }
      _addListeners();
    } on Exception catch (err) {
      print('error: $err');
    }
  }

   Future<void> stopPlayer() async {
    try {
      await playerModule.stopPlayer();
      print('stopPlayer');
      if (_playerSubscription != null) {
        await _playerSubscription.cancel();
        _playerSubscription = null;
      }
    } on Exception catch (err) {
      print('error: $err');
    }
  }

  void cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription.cancel();
      _recorderSubscription = null;
    }
  }

  void _addListeners() {
    cancelPlayerSubscriptions();
    _playerSubscription = playerModule.onProgress.listen((e) {
      _playerController.sink.add(e);
    });
  }

  void cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription.cancel();
      _playerSubscription = null;
    }
  }

  void askPermission() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException(
          'Microphone permission not granted');
    }
  }

  Stream<VoiceRecordState> _pauseResumePlayer() async* {
    try {
      if (playerModule.isPlaying) {
        await playerModule.pausePlayer();
        yield (VoiceRecordingEndWillSend(playerState: VoicePlayerState.paused));
      } else {
        await playerModule.resumePlayer();
        yield (VoiceRecordingEndWillSend(playerState: VoicePlayerState.playing));
      }
    } on Exception catch (err) {
      print('error: $err');
    }
  }

  Stream<VoiceRecordState> _mapPlayerStateToPlayerAction(VoiceStartResumeStop event) async*{
    switch (event.playerState){
      case VoicePlayerState.empty:
        startPlayer();
        yield (VoiceRecordingEndWillSend(playerState: VoicePlayerState.playing));
        break;
      default: 
      yield* _pauseResumePlayer();
    }
  }
}
