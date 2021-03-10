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

class AddMembersToChatParams {
  final int id;
  final List<int> members;

  AddMembersToChatParams({
    @required this.id,
    @required this.members
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