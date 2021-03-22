part of 'button_micro_cubit.dart';

abstract class ButtonMicroState extends Equatable {
  const ButtonMicroState();

  @override
  List<Object> get props => [];
}

class ButtonMicroInitialStable extends ButtonMicroState {}

class ButtonMicroMove extends ButtonMicroState {}

class ButtonMicroHold extends ButtonMicroState {}

class ButtonMicroDecreasing extends ButtonMicroState {
  final isDelete;

  ButtonMicroDecreasing({
    @required this.isDelete
  });

  @override
  List<Object> get props => [isDelete];
}
