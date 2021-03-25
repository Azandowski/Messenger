enum ChatBottomPanelTypes {
  contact, image, map, audio, camera,
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
      default:
        return '';
    }
  }
}