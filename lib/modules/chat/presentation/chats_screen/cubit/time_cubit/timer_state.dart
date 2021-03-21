part of 'timer_cubit.dart';

abstract class TimerState extends Equatable {
  
  final int timeLeft;
  
  const TimerState({
    @required this.timeLeft
  });

  @override
  List<Object> get props => [timeLeft];
}

class TimerNormal extends TimerState {
  final int timeLeft;

  TimerNormal({
    @required this.timeLeft
  });

  @override
  List<Object> get props => [timeLeft];
}
