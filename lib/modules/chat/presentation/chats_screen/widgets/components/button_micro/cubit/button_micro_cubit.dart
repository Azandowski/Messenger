import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../pages/chat_screen_import.dart';

part 'button_micro_state.dart';

class ButtonMicroCubit extends Cubit<ButtonMicroState> {
  ButtonMicroCubit() : super(ButtonMicroInitialStable());

  void makeDecreasingDelete(){
    emit(ButtonMicroDecreasing(isDelete: true));
  }

  void makeDecreasingSend(){
    emit(ButtonMicroDecreasing(isDelete: false));
  }

  void resetToStable(){
    emit(ButtonMicroInitialStable());
  }

  void startMovement(){
    emit(ButtonMicroMove());
  }

  void holdRecording(){
    emit(ButtonMicroHold());
  }

}
