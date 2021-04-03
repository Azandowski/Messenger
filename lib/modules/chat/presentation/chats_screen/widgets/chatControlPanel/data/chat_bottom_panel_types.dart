enum ChatBottomPanelTypes {
  contact, image, map, audio, camera, video,
}

extension ChatBottomPanelTypesUIExtension on ChatBottomPanelTypes {
  String get assetPath {
    switch (this) {
      case ChatBottomPanelTypes.contact:
        return 'assets/icons/contact.png';
      case ChatBottomPanelTypes.image:
        return 'assets/icons/media.png';
      case ChatBottomPanelTypes.map:
        return 'assets/icons/place.png';
      case ChatBottomPanelTypes.audio:
        return 'assets/icons/audio.png';
      case ChatBottomPanelTypes.camera:
        return 'assets/icons/camera.png';
      case ChatBottomPanelTypes.video:
        return 'assets/icons/videopanel.png';
      default:
        return '';
    }
  }
  
  String get title {
    switch (this) {
      case ChatBottomPanelTypes.contact:
        return 'Контакт';
      case ChatBottomPanelTypes.image:
        return 'Галерея';
      case ChatBottomPanelTypes.map:
        return 'Место';
      case ChatBottomPanelTypes.audio:
        return 'Аудио';
      case ChatBottomPanelTypes.camera:
        return 'Камера';
      case ChatBottomPanelTypes.video:
        return 'Видео';
      default:
        return '';
    }
  }
}