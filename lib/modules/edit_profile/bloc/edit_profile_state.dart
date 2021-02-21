import 'package:equatable/equatable.dart';

abstract class EditProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {}

class EditProfileNormal extends EditProfileState {}

class EditProfileError extends EditProfileState {
  final String message;

  EditProfileError ({
    this.message
  });

  @override
  List<Object> get props => [message];
}