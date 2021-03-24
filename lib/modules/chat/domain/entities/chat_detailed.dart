import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../profile/domain/entities/user.dart';
import '../../../social_media/domain/entities/social_media.dart';

import '../../../category/domain/entities/chat_entity.dart';
import '../../../category/domain/entities/chat_permissions.dart';
import '../../../creation_module/domain/entities/contact.dart';

class ChatDetailed extends Equatable {
  final User user;
  final ChatEntity chat;
  final MediaStats media;
  final ChatPermissions settings;
  final List<ContactEntity> members;
  final int membersCount;
  final ChatMember chatMemberRole;
  final List<ChatEntity> groups;
  final SocialMedia socialMedia;

  ChatDetailed({
    @required this.chat, 
    @required this.media, 
    @required this.members,
    @required this.membersCount,
    @required this.chatMemberRole,
    @required this.user,
    this.groups,
    this.settings, 
    this.socialMedia
  });  

  ChatDetailed copyWith ({
    ChatEntity chat, 
    MediaStats media, 
    List<ContactEntity> members,
    int membersCount,
    ChatPermissions settings,
    ChatMember chatMemberRole,
    User user,
    List<ChatEntity> groups,
    SocialMedia socialMedia
  }) {
    return ChatDetailed(
      chat: chat ?? this.chat,
      media: media ?? this.media,
      members: members ?? this.members,
      membersCount: membersCount ?? this.membersCount,
      settings: settings ?? this.settings,
      chatMemberRole: chatMemberRole ?? this.chatMemberRole,
      user: user ?? this.user,
      groups: groups ?? this.groups,
      socialMedia: socialMedia ?? this.socialMedia
    );
  }

  @override
  List<Object> get props => [
    membersCount, 
    members, 
    chat, 
    media,
    settings, 
    chatMemberRole,
    user,
    groups,
    socialMedia
  ];
}

enum ChatMember {
  admin, member
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