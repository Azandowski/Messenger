import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';

import '../../../../domain/entities/message.dart';
import '../../pages/chat_screen_import.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  Timer _timer;
  int timeLeftInSeconds;
  Message message;

  TimerCubit(Message message) : super(TimerNormal(timeLeft: null)) {
    this.message = message;
    int myUserID = sl<AuthConfig>().user?.id;
    if ((message.isRead || message.user?.id != myUserID) &&
        message.timeDeleted != null) {
      timeLeftInSeconds = message.timeDeleted -
          DateTime.now().difference(message.dateTime).inSeconds;
      emit(TimerNormal(timeLeft: timeLeftInSeconds));

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (timeLeftInSeconds >= 0) {
          timeLeftInSeconds -= 1;
          emit(TimerNormal(timeLeft: timeLeftInSeconds));
        } else {
          _timer.cancel();
        }
      });
    }
  }

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }
}
