import 'package:messenger_mobile/modules/authentication/domain/entities/code_entity.dart';

class CodeResponse extends CodeEntity {
  final int id;
  final String phone;
  final String code;
  final int attempts;

  CodeResponse({this.id, this.phone, this.code, this.attempts});

  CodeResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        phone = json['phone'],
        code = json['code'],
        attempts = json['attempts'];
}
