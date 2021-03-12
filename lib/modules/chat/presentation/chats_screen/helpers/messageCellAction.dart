enum MessageCellActions {
  createGroup, 
  createSecretChat, 
  startVideo,
  startLive,
  inviteFriends
}

extension CreationActionsUIExtension on MessageCellActions {
  String get title {
    switch (this) {
      case MessageCellActions.createGroup:
        return 'Создать группу';
      case MessageCellActions.createSecretChat:
        return 'Создать секретный чат';
      case MessageCellActions.startVideo:
        return 'Начать видеоконференцию';
      case MessageCellActions.startLive:
        return 'Начать прямой эфир';
      case MessageCellActions.inviteFriends:
        return 'Пригласить друзей';
      default:
        return '';
    }
  }

  String get iconAssetPath {
    switch (this) {
      case MessageCellActions.createGroup:
        return 'assets/icons/groups.png';
      case MessageCellActions.createSecretChat:
        return 'assets/icons/private.png';
      case MessageCellActions.startVideo:
        return 'assets/icons/video.png';
      case MessageCellActions.startLive:
        return 'assets/icons/live.png';
      case MessageCellActions.inviteFriends:
        return 'assets/icons/create.png';
      default:
        return '';
    }
  }
}