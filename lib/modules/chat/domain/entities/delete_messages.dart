import 'package:equatable/equatable.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';

class DeleteMessageEntity extends Equatable{
  final List<int> messagesIds;
  final DeleteActionType deleteActionType;
  final int userId;
  DeleteMessageEntity({
    @required this.deleteActionType,
    @required this.userId,
    @required this.messagesIds,
  });

  @override
  List<Object> get props => [messagesIds, deleteActionType,userId];

}

enum DeleteActionType{
  deleteAll,
  deleteSelf,
}