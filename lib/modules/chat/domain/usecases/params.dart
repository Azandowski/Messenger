import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chat/data/datasources/chat_datasource.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_chat_details.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/page/chat_detail_screen.dart';
import 'package:messenger_mobile/modules/social_media/domain/entities/social_media.dart';

import '../../../../core/utils/pagination.dart';
import '../../../category/data/models/chat_permission_model.dart';

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

  SendMessageParams({
    @required this.identificator,
    @required this.chatID,
    this.forwardIds,
    this.text,
    this.timeLeft
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