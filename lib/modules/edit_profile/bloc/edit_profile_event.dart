import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';


abstract class EditProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class EditProfileInit extends EditProfileEvent {
  final User user;

  EditProfileInit({
    @required this.user
  });

  @override
  List<Object> get props => [
    user
  ];
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

  @override
  List<Object> get props => [
    token, image, name, surname, patronym, phoneNumber
  ];
}

class PickProfileImage extends EditProfileEvent {
  final ImageSource imageSource;

  PickProfileImage({
    @required this.imageSource
  });

  @override
  List<Object> get props => [imageSource];
}

