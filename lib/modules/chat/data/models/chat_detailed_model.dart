
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_entity_model.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_permission_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_model.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';

class ChatDetailedModel extends ChatDetailed {
  final ChatEntity chat;
  final MediaStats media;
  final ChatPermissionModel settings;
  final List<ContactEntity> members;
  final int membersCount;

  ChatDetailedModel({
    @required this.chat, 
    @required this.media, 
    @required this.members,
    @required this.membersCount,
    this.settings, 
  }) : super(
    chat: chat,
    media: media,
    members: members,
    membersCount: membersCount
  );

  factory ChatDetailedModel.fromJson (Map<String, dynamic> json) {
    return ChatDetailedModel(
      chat: ChatEntityModel.fromJson(json['chat']),
      media: MediaStatsModel.fromJson(json['media']),
      membersCount: json['count_member'],
      members: ((json['members'] ?? []) as List).map(
        (e) => ContactModel.fromJson(e)
      ).toList()
    );
  }
}

class MediaStatsModel extends MediaStats {
  final int mediaCount;
  final int documentCount;
  final int audioCount;

  MediaStatsModel({
    @required this.mediaCount, 
    @required this.documentCount, 
    @required this.audioCount
  }) : super(
    mediaCount: mediaCount,
    documentCount: documentCount,
    audioCount: audioCount
  );

  factory MediaStatsModel.fromJson (Map<String, dynamic> json) {
    return MediaStatsModel(
      mediaCount: json['media'],
      documentCount: json['document'],
      audioCount: json['audio']
    );
  }
}