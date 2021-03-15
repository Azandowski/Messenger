import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_permission_model.dart';

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
  final int seconds;

  SetTimeDeletedParams({
    @required this.id,
    @required this.seconds
  });
}