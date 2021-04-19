import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/services/network/config.dart';

import '../../domain/entities/contact.dart';

class ContactModel extends ContactEntity {
  final int id;
  final String name;
  final String surname;
  final String patronym;
  final String avatar;
  final DateTime lastVisit;

  @override
  String toString() {
    return "$id $name $surname $patronym $avatar $lastVisit";
  }

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
    var lastVisit = json['last_visit'] != null
        ? DateTime.parse(json['last_visit']).toLocal()
        : null;
    if (lastVisit != null) {
      lastVisit = lastVisit.add(lastVisit.timeZoneOffset);
    }

    return ContactModel(
      id: json['id'],
      name: json['name'],
      patronym: json['patronym'] ?? '',
      surname: json['surname'] ?? '',
      lastVisit: lastVisit,
      avatar: json['avatar'] != null ? 
        ConfigExtension.buildURLHead() + json['avatar'] : null,
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

  @override
  List<Object> get props => [id, name, surname, patronym, avatar, lastVisit];
}
