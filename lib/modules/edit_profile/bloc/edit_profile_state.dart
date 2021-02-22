import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class EditProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {}

class EditProfileNormal extends EditProfileState {
  final File imageFile;
  
  EditProfileNormal ({
    this.imageFile
  });

  @override
  List<Object> get props => [imageFile];
}

class EditProfileError extends EditProfileState {
  final String message;

  EditProfileError ({
    this.message
  });

  @override
  List<Object> get props => [message];
}