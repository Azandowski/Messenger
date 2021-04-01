import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  Timer _timer;
  int timeLeftInSeconds;

  TimerCubit(Message message) : super(TimerNormal(timeLeft: null)) {
    if (message.isRead && message.timeDeleted != null) {
      timeLeftInSeconds = message.timeDeleted -
          DateTime.now().difference(message.dateTime).inSeconds;

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (timeLeftInSeconds >= 0) {
          timeLeftInSeconds -= 1;
          emit(TimerNormal(timeLeft: timeLeftInSeconds));
        } else {
          print('delete message');
          // chatBloc.add(MessageDelete(
          //   ids: [message.id]
          // ));
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
