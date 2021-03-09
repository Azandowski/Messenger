import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class CreateChatGroupParams extends Equatable {
  final String token;
  final String description;
  final File avatarFile;
  final String name;
  final List<int> contactIds;
  final bool isCreate;
  final int chatGroupId;

  CreateChatGroupParams({
    @required this.token,
    @required this.avatarFile, 
    @required this.name, 
    @required this.contactIds,
    @required this.isCreate,
    this.description,
    this.chatGroupId
  }) {
    if (!isCreate) {
      assert(chatGroupId != null, 'chat ID should be null for editing it');
    }
  }

  @override
  List<Object> get props => [token, avatarFile, name, contactIds];
}