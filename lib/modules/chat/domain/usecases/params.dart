import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chat/data/datasources/chat_datasource.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/page/chat_detail_screen.dart';
import 'package:messenger_mobile/modules/social_media/domain/entities/social_media.dart';
import 'package:latlong/latlong.dart';

import '../../../../core/utils/pagination.dart';
import '../../../category/data/models/chat_permission_model.dart';
import '../../../social_media/domain/entities/social_media.dart';
import '../../data/datasources/chat_datasource.dart';
import '../../presentation/chat_details/page/chat_detail_screen.dart';
import '../../presentation/chat_details/widgets/chat_media_block.dart';

class GetChatMembersParams {
  final int id;
  final Pagination pagination;

  GetChatMembersParams({
    @required this.id, 
    @required this.pagination
  });
}

class SendMessageParams {
  final List<int> forwardIds;
  final text;
  final chatID; 
  final int identificator;
  final int timeLeft;
  final FieldFiles fieldFiles;
  final LatLng location;
  final String locationAddress;
  final int contactID;

  SendMessageParams({
    @required this.identificator,
    @required this.chatID,
    this.forwardIds,
    this.fieldFiles,
    this.text,
    this.timeLeft,
    this.location,
    this.locationAddress,
    this.contactID
  });
}

extension FileKeysExtension on MediaType {
  String get filedKey {
    switch (this) {
      case MediaType.audio:
      return 'audio';
      default:
      return 'photo';
    }
  }
}

class FieldFiles {
  final MediaType fieldKey;
  final List<File> files;

  FieldFiles({
    @required this.fieldKey,
    @required this.files
  });

}

class AddMembersToChatParams {
  final int id;
  final List<int> members;

  AddMembersToChatParams({
    @required this.id,
    @required this.members
  });
}

class KickMemberParams {
  final int id;
  final int userID;

  KickMemberParams({
    @required this.id,
    @required this.userID
  });
}


class UpdateChatSettingsParams {
  final int id;
  final ChatPermissionModel permissionModel;

  UpdateChatSettingsParams({
    @required this.id,
    @required this.permissionModel
  });
}


class SetTimeDeletedParams {
  final int id;
  final bool isOn;

  SetTimeDeletedParams({
    @required this.id,
    @required this.isOn
  });
}

class DeleteMessageParams {
  final String ids;
  final int forMe;
  final int chatID; 

  DeleteMessageParams({
    @required this.ids,
    @required this.forMe,
    @required this.chatID,
  });

  Map get body {
    return {
      'for_me': forMe.toString(),
      'messages': ids,
      'chat_id': chatID.toString(),
    };
  }
}


class GetMessagesContextParams {
  final int chatID;
  final int messageID;

  GetMessagesContextParams({
    @required this.chatID,
    @required this.messageID
  });
}


class GetMessagesParams {
  final int lastMessageId;
  final RequestDirection direction;

  GetMessagesParams({
    @required this.lastMessageId,
    @required this.direction
  });
}

class ReplyMoreParams {
  final List<int> chatIds;
  final List<int> messageIds;

  ReplyMoreParams({
    @required this.chatIds,
    @required this.messageIds
  });
}

class GetChatDetailsParams {
  final ProfileMode mode;
  final int id;

  GetChatDetailsParams ({
    @required this.mode,
    @required this.id
  });
}

class BlockUserParams {
  final bool isBloc;
  final int userID;

  BlockUserParams({
    @required this.isBloc,
    @required this.userID
  });
}

class SetSocialMediaParams {
  final int id;
  final SocialMedia socialMedia;

  SetSocialMediaParams({
    @required this.id,
    @required this.socialMedia
  });
}

class MarkAsReadParams {
  final int id;
  final int messageID;

  MarkAsReadParams({
    @required this.id,
    @required this.messageID
  });
}