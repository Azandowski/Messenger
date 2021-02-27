import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';

class ContactModel extends Contact {
  final DateTime lastOnline;
  final String name;
  final String avatarURL;

  ContactModel({
    @required this.lastOnline,
    this.name,
    this.avatarURL
  }) : super(
    lastOnline: lastOnline,
    name: name,
    avatarURL: avatarURL
  );

  // TODO: Update From Json Method

  factory ContactModel.fromJson (Map<String, dynamic> json) {
    return ContactModel(
      lastOnline: DateTime.parse('2021-02-27T19:30:47.000000Z'),
      name: 'Yelzhan Yerkebulan',
      avatarURL: 'https://st3.depositphotos.com/15648834/17930/v/600/depositphotos_179308454-stock-illustration-unknown-person-silhouette-glasses-profile.jpg'
    );
  }
}