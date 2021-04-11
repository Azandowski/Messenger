import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  AudioPlayerBloc() : super(AudioPlayerState.empty()) {
    _initializeExample(true);
  }

  Codec _codec = Codec.aacADTS; 

  FlutterSoundPlayer player = FlutterSoundPlayer();

  @override
  Stream<AudioPlayerState> mapEventToState(AudioPlayerEvent event) async* {
    if(event is StopPlayer){
      stopPlayer();
      yield AudioPlayerState.empty();
    }else if(event is PlayLocalPlayer){
      startPlayer(event.path);
      yield AudioPlayerState.playing(event.path);
    }else if(event is StartResumeStop){
        try {
        if(event.path == this.state.id){
          if(this.state.status == VoicePlayerState.empty){
              this.add(PlayLocalPlayer(path: event.path));
          }else{
            if (player.isPlaying) {
              await player.pausePlayer();
              yield AudioPlayerState.paused(event.path);
            } else {
              await player.resumePlayer();
              yield AudioPlayerState.playing(event.path,);
            }
          }
        }else{
          stopPlayer();
          this.add(PlayLocalPlayer(path: event.path));
        }
      } on Exception catch (err) {
        print('error: $err');
      }
    }else if(event is ResetPlayer){
      yield AudioPlayerState.empty();
    }
  }

   Future<void> startPlayer(String path) async {
    try {
      String audioFilePath;
      var codec = _codec;
      audioFilePath = path;
      final fileUri = path;
       Track track = Track(
        codec: _codec,
        trackPath: fileUri,
        trackAuthor: 'Aio',
        trackTitle: 'AIO Voice',
        albumArtAsset: "assets/images/logo.png");

      if (audioFilePath != null) {
        await player.startPlayerFromTrack(track,
        onPaused: (bool paused){
          this.add(StartResumeStop(path: path));
        },
          whenFinished: () {
            this.add(ResetPlayer());
            _playerController.sink.add(PlaybackDisposition());
            cancelPlayerSubscriptions();
          });
      }
      _addListeners();
    } on Exception catch (err) {
      print('error: $err');
    }
  }

  Future<void> stopPlayer() async {
    try {
      await player.stopPlayer();
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
    await player.openAudioSession(
        withUI: withUI,
        focus: AudioFocus.requestFocusAndKeepOthers,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeVoiceChat,
        device: AudioDevice.speaker);
    await player.setSubscriptionDuration(Duration(milliseconds: 10));
  }

   void _addListeners() {
    cancelPlayerSubscriptions();
    _playerSubscription = player.onProgress.listen((e) {
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
