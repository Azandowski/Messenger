import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CodeEntity extends Equatable {
  final int id;
  final String phone;
  final String code;
  final int attempts;

  CodeEntity(
      {@required this.id,
      @required this.phone,
      @required this.code,
      @required this.attempts});

  @override
  List<Object> get props => [id, phone, code, attempts];
}
