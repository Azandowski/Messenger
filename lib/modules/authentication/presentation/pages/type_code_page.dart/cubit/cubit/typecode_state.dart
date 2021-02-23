part of 'typecode_cubit.dart';

abstract class TypeCodeState extends Equatable {
  const TypeCodeState();

  @override
  List<Object> get props => [];
}

class TypecodeInitial extends TypeCodeState {}

class SendingCode extends TypeCodeState {}

class InvalidCode extends TypeCodeState {
  final String message;

  InvalidCode(this.message);
}

class SuccessCode extends TypeCodeState {
  final TokenEntity tokenEntity;

  SuccessCode(this.tokenEntity);
}
