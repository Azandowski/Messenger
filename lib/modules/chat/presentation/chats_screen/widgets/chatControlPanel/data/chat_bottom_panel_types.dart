import 'package:easy_localization/easy_localization.dart';

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
        return 'contact'.tr();
      case ChatBottomPanelTypes.image:
        return 'gallery'.tr();
      case ChatBottomPanelTypes.map:
        return 'place'.tr();
      case ChatBottomPanelTypes.audio:
        return 'audio'.tr();
      case ChatBottomPanelTypes.camera:
        return 'camera'.tr();
      case ChatBottomPanelTypes.video:
        return 'video'.tr();
      default:
        return '';
    }
  }
}