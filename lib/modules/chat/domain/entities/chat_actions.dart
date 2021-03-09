enum ChatActions {
  addUser
}

extension ChatActionsExtension on ChatActions {
  String get key {
    switch (this) {
      case ChatActions.addUser:
        return 'Ad user';
    }
  }
}