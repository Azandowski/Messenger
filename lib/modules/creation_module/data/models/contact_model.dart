import 'package:flutter/foundation.dart';

import '../../domain/entities/contact.dart';

class ContactModel extends ContactEntity {
  final int id;
  final String name;
  final String surname;
  final String patronym;
  final String avatar;
  final DateTime lastVisit;

  ContactModel({
    this.avatar,
    @required this.name,
    this.surname,
    this.patronym,
    this.lastVisit,
    @required this.id,
  }) : super(
    lastVisit: lastVisit,
    name: name,
    avatar: avatar,
    surname: surname,
    patronym: patronym,
    id: id,
  );

   factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'],
      name: json['name'],
      patronym: json['patronym'] ?? '',
      surname: json['surname'] ?? '',
      lastVisit: json['last_visit'] != null ? DateTime.parse(json['last_visit']).toLocal() : null,
      avatar: json['avatar'],
      );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['patronym'] = this.patronym;
    data['avatar'] = this.avatar;
    data['last_visit'] = this.lastVisit;
    return data;
  }
}