import 'package:equatable/equatable.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';

abstract class EditProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {}

class EditProfileNormal extends EditProfileState {
  final User user;
  
  EditProfileNormal ({
    this.user
  });

  @override
  List<Object> get props => [user];
}

class EditProfileError extends EditProfileState {
  final String message;

  EditProfileError ({
    this.message
  });

  @override
  List<Object> get props => [message];
}