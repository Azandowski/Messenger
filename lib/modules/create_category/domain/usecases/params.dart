import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class CreateCategoryParams extends Equatable {
  final String token;
  final File avatarFile;
  final String name;
  final List<int> chatIds;

  CreateCategoryParams({
    @required this.token,
    @required this.avatarFile, 
    @required this.name, 
    @required this.chatIds,
  });

  @override
  List<Object> get props => [token, avatarFile, name, chatIds];
}