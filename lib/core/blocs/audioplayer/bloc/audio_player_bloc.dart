import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  AudioPlayerBloc() : super(AudioPlayerInitial(
    player: FlutterSoundPlayer(),
    playerState: VoicePlayerState.empty,
    uniqueId: ''
  )){
    _initializeExample(false);
  }

  Codec _codec = Codec.aacMP4;


  @override
  Stream<AudioPlayerState> mapEventToState(
    AudioPlayerEvent event,
  ) async* {
    if(event is StopPlayer){
      stopPlayer();
      yield (AudioPlayerInitial(playerState: VoicePlayerState.empty, player: this.state.player, uniqueId: this.state.uniqueId));
    }else if(event is PlayLocalPlayer){
      startPlayer(event.path);
      yield AudioPlayerInitial(playerState: VoicePlayerState.playing, player: this.state.player, uniqueId: this.state.uniqueId);
    }else if(event is StartResumeStop){
       try {
        if(this.state.playerState == VoicePlayerState.empty){
            this.add(PlayLocalPlayer(path: event.path));
        }else{
          if (this.state.player.isPlaying) {
            await this.state.player.pausePlayer();
            yield (AudioPlayerInitial(playerState: VoicePlayerState.paused, player: this.state.player, uniqueId: event.path));
          } else {
            await this.state.player.resumePlayer();
            yield (AudioPlayerInitial(playerState: VoicePlayerState.playing, player: this.state.player, uniqueId: event.path));
          }
         }
    } on Exception catch (err) {
      print('error: $err');
    }
  }else if(event is ResetPlayer){
    yield (AudioPlayerInitial(playerState: VoicePlayerState.empty, player: this.state.player, uniqueId: this.state.uniqueId));
  }
  }

   Future<void> startPlayer(String path) async {
    try {
      String audioFilePath;
      var codec = _codec;
      audioFilePath = path;
      if (audioFilePath != null) {
        await this.state.player.startPlayer(
          fromURI: audioFilePath,
          codec: codec,
          sampleRate: 32000,
          whenFinished: () {
            this.add(ResetPlayer());
            cancelPlayerSubscriptions();
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
      await this.state.player.stopPlayer();
      if (_playerSubscription != null) {
        await _playerSubscription.cancel();
        _playerSubscription = null;
      }
    } on Exception catch (err) {
      print('error: $err');
    }
  }

  var _playerController = StreamController<PlaybackDisposition>.broadcast();
  Stream<PlaybackDisposition> get playerStream => _playerController.stream;

  StreamSubscription<PlaybackDisposition> _playerSubscription;



   Future<void> _initializeExample(bool withUI) async {
    await this.state.player.openAudioSession(
        withUI: withUI,
        focus: AudioFocus.requestFocusAndStopOthers,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);
    await this.state.player.setSubscriptionDuration(Duration(milliseconds: 10));
  }

   void _addListeners() {
    cancelPlayerSubscriptions();
    _playerSubscription = this.state.player.onProgress.listen((e) {
      _playerController.sink.add(e);
    });
  }

  void cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription.cancel();
      _playerSubscription = null;;
    }
  }
}