enum ChatUpdateType {
  newLastMessage,
  updateChatSettings,
  chatEdit,
  readMessage
}

extension ChatUpdateTypeExtension on ChatUpdateType {
  String get key {
    switch (this) {
      case ChatUpdateType.newLastMessage:
        return 'newmessage';
      case ChatUpdateType.updateChatSettings:
        return 'UpdateSettingsChat';
      case ChatUpdateType.chatEdit:
        return 'chatedit';
      case ChatUpdateType.readMessage:
        return 'MessageRead';
    }
  }
}

extension ChatUpdateTypeStringExtension on String {
  ChatUpdateType get getChatUpdateType {
    return ChatUpdateType.values.firstWhere((e) => e.key == this, orElse: () => ChatUpdateType.newLastMessage);
  }
}

