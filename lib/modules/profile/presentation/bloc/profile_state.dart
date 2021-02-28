import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

abstract class ProfileState extends Equatable {
  final User user;
  
  ProfileState(this.user);

  @override
  List<Object> get props => [user];
}

class ProfileLoading extends ProfileState {
  final User user;

  ProfileLoading({
    @required this.user
  }) : super(user);

  @override
  List<Object> get props => [user];
}

class ProfileLoaded extends ProfileState {
  final User user;

  ProfileLoaded({
    @required this.user
  }) : super(user);

  @override
  List<Object> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;
  final User user;

  ProfileError({
    @required this.message,
    @required this.user
  }) : super(user);

  @override
  List<Object> get props => [message, user];
}
