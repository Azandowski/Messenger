import '../../domain/entities/message.dart';
import 'message_user_model.dart';

class MessageModel extends Message {
  final int id;
  final bool isRead;
  final DateTime dateTime;
  final String text;
  final MessageUser user;

  MessageModel({
    this.id,
    this.isRead,
    this.dateTime,
    this.text,
    this.user
  }) : super(
    id: id,
    isRead: isRead,
    text: text,
    dateTime: dateTime,
    user: user
  );

  factory MessageModel.fromJson(Map json) {
    return MessageModel(
      id: json['id'],
      user: json['from_contact'] != null ? MessageUserModel.fromJson(json['from_contact']) : null,
      text: json['text'],
      isRead: json['is_read'] == 1,
      dateTime: DateTime.parse(json['created_at'])
    );
  }
}