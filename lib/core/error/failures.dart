import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/maps/data/datasources/local_map_datasource.dart';

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
  ConnectionFailure() : super(message: 'no_connection');
}

class GeolocationFailure extends Failure {
  final LocationFailure failure;

  GeolocationFailure(this.failure) : super(message: failure.message);
}


abstract class FailureMessages {
  static final String noConnection = "no_connection";
  static final String invalidPhone = "invalidPhone";
  static final String invalidCode = "invalidCode";
}


