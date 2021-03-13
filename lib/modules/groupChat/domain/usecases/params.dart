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
  final bool isPrivate;

  CreateChatGroupParams({
    @required this.token,
    @required this.contactIds,
    @required this.isCreate,
    this.avatarFile, 
    this.name, 
    this.description,
    this.chatGroupId,
    this.isPrivate = false
  }) {
    if (!isCreate) {
      assert(chatGroupId != null, 'chat ID should be null for editing it');
    }
  }

  @override
  List<Object> get props => [
    token, avatarFile, name, contactIds,
    isPrivate, chatGroupId, isCreate
  ];
}