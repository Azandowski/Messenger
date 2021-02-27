enum CreationActions {
  createGroup, 
  createSecretChat, 
  startVideo,
  startLive,
  inviteFriends
}

extension CreationActionsUIExtension on CreationActions {
  String get title {
    switch (this) {
      case CreationActions.createGroup:
        return 'Создать группу';
      case CreationActions.createSecretChat:
        return 'Создать секретный чат';
      case CreationActions.startVideo:
        return 'Начать видеоконференцию';
      case CreationActions.startLive:
        return 'Начать прямой эфир';
      case CreationActions.inviteFriends:
        return 'Пригласить друзей';
      default:
        return '';
    }
  }

  String get iconAssetPath {
    switch (this) {
      case CreationActions.createGroup:
        return 'assets/icons/groups.png';
      case CreationActions.createSecretChat:
        return 'assets/icons/private.png';
      case CreationActions.startVideo:
        return 'assets/icons/video.png';
      case CreationActions.startLive:
        return 'assets/icons/live.png';
      case CreationActions.inviteFriends:
        return 'assets/icons/create.png';
      default:
        return '';
    }
  }
}