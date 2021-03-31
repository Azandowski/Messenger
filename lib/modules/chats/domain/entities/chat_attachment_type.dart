enum ChatAttachmentType {
  file, map, contact, none
}

extension ChatAttachmentTypeExtension on ChatAttachmentType {
  String get iconPath {
    switch (this) {
      case ChatAttachmentType.file:
        return 'assets/icons/chat/document_small.png';
      case ChatAttachmentType.map:
        return 'assets/icons/chat/location_small.png';
      case ChatAttachmentType.contact:
        return 'assets/icons/chat/contact_small.png';
      default:
        return null;
    }
  }

  String get title {
    switch (this) {
      case ChatAttachmentType.file:
        return 'Вложение';
      case ChatAttachmentType.map:
        return 'Координаты';
      case ChatAttachmentType.contact:
        return 'Контакт';
      default:
        return null; 
    }
  }

  String get key {
    switch (this) {
      case ChatAttachmentType.file:
        return 'file';
      case ChatAttachmentType.map:
        return 'map';
      case ChatAttachmentType.contact:
        return 'contact';
      default:
        return null; 
    }
  }
}