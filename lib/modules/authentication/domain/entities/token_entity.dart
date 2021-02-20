import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TokenEntity extends Equatable {
  final String token;

  TokenEntity({@required this.token});

  @override
  List<Object> get props => [token];
}
