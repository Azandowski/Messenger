import 'package:flutter/foundation.dart';

import '../../../category/data/models/chat_entity_model.dart';
import '../../../category/data/models/chat_permission_model.dart';
import '../../../category/domain/entities/chat_entity.dart';
import '../../../creation_module/data/models/contact_model.dart';
import '../../../creation_module/domain/entities/contact.dart';
import '../../../profile/data/models/user_model.dart';
import '../../../profile/domain/entities/user.dart';
import '../../../social_media/data/models/social_media_model.dart';
import '../../../social_media/domain/entities/social_media.dart';
import '../../domain/entities/chat_detailed.dart';

class ChatDetailedModel extends ChatDetailed {
  final User user;
  final ChatEntity chat;
  final MediaStats media;
  final ChatPermissionModel settings;
  final List<ContactEntity> members;
  final int membersCount;
  final ChatMember chatMemberRole;
  final List<ChatEntity> groups;
  final SocialMedia socialMedia;

  ChatDetailedModel(
      {@required this.chat,
      @required this.media,
      @required this.members,
      @required this.membersCount,
      @required this.chatMemberRole,
      @required this.user,
      this.settings,
      this.groups,
      this.socialMedia})
      : super(
            chat: chat,
            media: media,
            members: members,
            membersCount: membersCount,
            chatMemberRole: chatMemberRole,
            user: user,
            groups: groups,
            socialMedia: socialMedia);

  factory ChatDetailedModel.fromJson(Map<String, dynamic> json) {
    var profileModel =
        json['user'] ?? json['user_in_private_chat'] ?? json['chat'];
    bool hasSocialMedia = profileModel['youtube'] != null ||
        profileModel['instagram'] != null ||
        profileModel['facebook'] != null ||
        profileModel['site'] != null ||
        profileModel['whatsapp'] != null;

    return ChatDetailedModel(
        chat: json['chat'] != null
            ? ChatEntityModel.fromJson(json['chat'])
            : null,
        media: json['media'] != null
            ? MediaStatsModel.fromJson(json['media'])
            : null,
        membersCount: json['count_member'],
        members: ((json['members'] ?? []) as List)
            .map((e) => ContactModel.fromJson(e))
            .toList(),
        settings: ChatPermissionModel.fromJson(json['settings']),
        chatMemberRole:
            json['role'] == 'member' ? ChatMember.member : ChatMember.admin,
        user: json['user'] != null || json['user_in_private_chat'] != null
            ? UserModel.fromJson(json['user'] ?? json['user_in_private_chat'])
            : null,
        groups: ((json['equal_group'] ?? []) as List)
            .map((e) => ChatEntityModel.fromJson(e))
            .toList(),
        socialMedia:
            hasSocialMedia ? SocialMediaModel.fromJson(profileModel) : null);
  }
}

class MediaStatsModel extends MediaStats {
  final int mediaCount;
  final int documentCount;
  final int audioCount;

  @override
  String toString() {
    return "mediaCount:$mediaCount documentCount:$documentCount audioCount:$audioCount";
  }

  MediaStatsModel(
      {@required this.mediaCount,
      @required this.documentCount,
      @required this.audioCount})
      : super(
            mediaCount: mediaCount,
            documentCount: documentCount,
            audioCount: audioCount);

  factory MediaStatsModel.fromJson(Map<String, dynamic> json) {
    return MediaStatsModel(
        mediaCount: json['media'],
        documentCount: json['document'],
        audioCount: json['audio']);
  }
}
