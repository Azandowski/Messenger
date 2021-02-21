import 'package:flutter/material.dart';
import '../../domain/entities/code_entity.dart';

class CodeModel extends CodeEntity {
  final int id;
  final String phone;
  final String code;
  final int attempts;

  CodeModel({
    @required this.id,
    @required this.phone,
    @required this.code,
    @required this.attempts
  }) : super(id: id, phone: phone,  attempts: attempts);

  factory CodeModel.fromJson(Map<String, dynamic> json) {
    return CodeModel(
        id: json['id'],
        phone: json['phone'],
        code: json['code'],
        attempts: json['attempts']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'code': code,
      'attempts': attempts,
    };
  }
}
