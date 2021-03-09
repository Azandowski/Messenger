import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_permission_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';

class ChatDetailed extends Equatable {
  final ChatEntity chat;
  final MediaStats media;
  final ChatPermissionModel settings;
  final List<ContactEntity> members;
  final int membersCount;

  ChatDetailed({
    @required this.chat, 
    @required this.media, 
    @required this.members,
    @required this.membersCount,
    this.settings, 
  });  

  @override
  List<Object> get props => [
    membersCount, members, chat, media, settings
  ];
}

class MediaStats {
  final int mediaCount;
  final int documentCount;
  final int audioCount;

  MediaStats({
    @required this.mediaCount, 
    @required this.documentCount, 
    @required this.audioCount
  });
}