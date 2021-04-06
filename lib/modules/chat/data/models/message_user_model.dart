import 'package:flutter/foundation.dart';

import '../../../../core/services/network/config.dart';
import '../../domain/entities/message.dart';

class MessageUserModel extends MessageUser {
  final String name;
  final int id;
  final String avatarURL;
  final String phone;
  final String surname;

  MessageUserModel(
      {@required this.id, this.phone, this.avatarURL, this.name, this.surname})
      : super(
            id: id,
            name: name,
            phone: phone,
            surname: surname,
            avatarURL: avatarURL);

  factory MessageUserModel.fromJson(Map json) {
    return MessageUserModel(
        id: json['id'],
        name: json['name'],
        surname: json['surname'],
        avatarURL: json['avatar'] != null
            ? (json['avatar'] as String).contains('://')
                ? json['avatar']
                : ConfigExtension.buildURLHead() + json['avatar']
            : null,
        phone: json['phone']);
  }

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'avatar': avatarURL, // amanokerim fixed key from avatarURL to avatar
      'phone': phone,
    };
  }

  @override
  String toString() {
    return "MessageUserModel [name:$name id:$id avatarURL:$avatarURL phone:$phone surname:$surname]";
  }
}
