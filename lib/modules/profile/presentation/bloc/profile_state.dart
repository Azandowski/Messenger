import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  ProfileLoaded({@required this.user});

  @override
  List<Object> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({this.message});

  @override
  List<Object> get props => [message];
}
