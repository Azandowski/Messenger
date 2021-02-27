import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Contact extends Equatable {
  final DateTime lastOnline;
  final String name;
  final String avatarURL;

  Contact({
    @required this.lastOnline, 
    this.name, 
    this.avatarURL
  });

  @override
  List<Object> get props => [
    lastOnline, name, avatarURL
  ];
}