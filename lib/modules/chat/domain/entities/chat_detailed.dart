import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';

class ChatDetailed extends Equatable {
  final ChatEntity chat;
  final MediaStats media;
  final ChatPermissions settings;
  final List<ContactEntity> members;
  final int membersCount;
  final ChatMember chatMemberRole;

  ChatDetailed({
    @required this.chat, 
    @required this.media, 
    @required this.members,
    @required this.membersCount,
    @required this.chatMemberRole,
    this.settings, 
  });  

  ChatDetailed copyWith ({
    ChatEntity chat, 
    MediaStats media, 
    List<ContactEntity> members,
    int membersCount,
    ChatPermissions settings,
    ChatMember chatMemberRole
  }) {
    return ChatDetailed(
      chat: chat ?? this.chat,
      media: media ?? this.media,
      members: members ?? this.members,
      membersCount: membersCount ?? this.membersCount,
      settings: settings ?? this.settings,
      chatMemberRole: chatMemberRole ?? this.chatMemberRole
    );
  }

  @override
  List<Object> get props => [
    membersCount, members, chat, media, settings, chatMemberRole
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