import 'package:messenger_mobile/modules/chat/domain/entities/delete_messages.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import '../../../../core/extensions/string_extension.dart';
class DeleteMessageModel extends DeleteMessageEntity{
  final List<int> messagesIds;
  final DeleteActionType deleteActionType;
  final int userID;
  DeleteMessageModel({
    @required this.deleteActionType,
    @required this.messagesIds,
    @required this.userID,
  }) : super(deleteActionType: deleteActionType, messagesIds: messagesIds, userId: userID);

  factory DeleteMessageModel.fromJson(Map<String, dynamic> json) {
   return DeleteMessageModel(
    messagesIds: ((json['messages_id']?? []) as List).cast<int>(),
    deleteActionType: (json['type'] as String).getDeleteActionType,
    userID: json['user']
   );
  }
}