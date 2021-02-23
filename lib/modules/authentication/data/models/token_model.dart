import 'package:flutter/material.dart';

import '../../domain/entities/token_entity.dart';

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
