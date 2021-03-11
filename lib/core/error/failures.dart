import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class Failure extends Equatable {
  final String message;

  Failure({@required this.message});

  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {
  ServerFailure({@required message}) : super(message: message);
}

class StorageFailure extends Failure {
  StorageFailure() : super(message: null);
}

class ConnectionFailure extends Failure {
  ConnectionFailure() : super(message: FailureMessages.noConnection);
}

abstract class FailureMessages {
  static final String noConnection = "noConnection";
  static final String invalidPhone = "invalidPhone";
  static final String invalidCode = "invalidCode";
}
