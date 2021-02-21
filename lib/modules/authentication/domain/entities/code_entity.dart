import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CodeEntity extends Equatable {
  final int id;
  final String phone;
  final int attempts;

  CodeEntity({
    @required this.phone,
    this.attempts,
    this.id,
  });

  @override
  List<Object> get props => [id, phone, attempts];
}
