
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/profile/data/models/user_model.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import '../../../category/data/models/chat_entity_model.dart';
import '../../../category/data/models/chat_permission_model.dart';
import '../../../category/domain/entities/chat_entity.dart';
import '../../domain/entities/chat_detailed.dart';
import '../../../creation_module/data/models/contact_model.dart';
import '../../../creation_module/domain/entities/contact.dart';

class ChatDetailedModel extends ChatDetailed {
  final User user;
  final ChatEntity chat;
  final MediaStats media;
  final ChatPermissionModel settings;
  final List<ContactEntity> members;
  final int membersCount;
  final ChatMember chatMemberRole;
  final List<ChatEntity> groups;

  ChatDetailedModel({
    @required this.chat, 
    @required this.media, 
    @required this.members,
    @required this.membersCount,
    @required this.chatMemberRole,
    @required this.user,
    this.settings, 
    this.groups
  }) : super(
    chat: chat,
    media: media,
    members: members,
    membersCount: membersCount,
    chatMemberRole: chatMemberRole,
    user: user,
    groups: groups
  );

  factory ChatDetailedModel.fromJson (Map<String, dynamic> json) {
    return ChatDetailedModel(
      chat: json['chat'] != null ?
        ChatEntityModel.fromJson(json['chat']) : null,
      media: json['media'] != null ?
        MediaStatsModel.fromJson(json['media']) : null,
      membersCount: json['count_member'],
      members: ((json['members'] ?? []) as List).map(
        (e) => ContactModel.fromJson(e)
      ).toList(),
      settings: ChatPermissionModel.fromJson(json['settings']),
      chatMemberRole: json['role'] == 'member' ? ChatMember.member : ChatMember.admin,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      groups: ((json['equal_group'] ?? []) as List)
        .map((e) => ChatEntityModel.fromJson(e)).toList()
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