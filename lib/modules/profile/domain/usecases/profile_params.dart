import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class GetUserParams extends Equatable {
  final String token;

  GetUserParams({
    @required this.token
  });

  @override
  List<Object> get props => [token];
}

class EditUserParams extends Equatable {
  final String token;
  final File image;
  final String name;
  final String surname;
  final String patronym;
  final String phoneNumber;
  final String status;

  EditUserParams ({
    @required this.token, 
    this.image,
    this.name,
    this.surname,
    this.patronym,
    this.phoneNumber,
    this.status
  });

  Map<String, String> get jsonBody {
    return {
      if (name != null) ...{'name': name},
      if (surname != null) ...{'surname': surname},
      if (patronym != null) ...{'patronym': patronym},
      if (phoneNumber != null) ...{'phone': phoneNumber},
      if (status != null) ...{'status': status}
    };
  }

  @override
  List<Object> get props => [
    token, image, name, phoneNumber, patronym, surname, status
  ];
}