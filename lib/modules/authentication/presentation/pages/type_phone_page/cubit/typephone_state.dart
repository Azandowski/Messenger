part of 'typephone_cubit.dart';

abstract class TypephoneState extends Equatable {
  const TypephoneState();

  @override
  List<Object> get props => [];
}

class TypephoneInitial extends TypephoneState {}

class SendingPhone extends TypephoneState {}

class InvalidPhone extends TypephoneState {
  final String message;

  InvalidPhone(this.message);
}

class Success extends TypephoneState {
  final CodeEntity codeEntity;

  Success(this.codeEntity);
}
