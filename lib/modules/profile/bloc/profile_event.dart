import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';


abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String token;

  LoadProfile ({
    @required this.token
  });

  @override
  List<Object> get props => [token];
}


