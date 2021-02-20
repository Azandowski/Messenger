import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/token_entity.dart';

class TokenModel extends TokenEntity {
  final String token;

  TokenModel({@required this.token}) : super(token: token);

  factory TokenModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      TokenModel(
        token: json['access_token'],
      );

  Map<String, dynamic> toJson() {
    return {
      'access_token': token,
    };
  }
}
