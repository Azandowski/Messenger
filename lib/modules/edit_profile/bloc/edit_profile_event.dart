import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';


abstract class EditProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class EditProfileUpdateUser extends EditProfileEvent {
  final File image; 
  final String name;
  final String surname;
  final String patronym;
  final String token;
  final String phoneNumber;

  EditProfileUpdateUser({
    @required this.token,
    this.image, 
    this.name, 
    this.surname, 
    this.patronym, 
    this.phoneNumber
  });
}

// class EditProfileInit extends EditProfileEvent {}

