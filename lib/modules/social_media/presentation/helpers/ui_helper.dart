import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/social_media/domain/entities/social_media.dart';

extension SocialMediaTypeUIExtension on SocialMediaType {
  String get assetImagePath {
    switch (this) {
      case SocialMediaType.youtube:
        return 'assets/icons/social_media/youtube.png';
      case SocialMediaType.facebook:
        return 'assets/icons/social_media/facebook.png';
      case SocialMediaType.instagram:
        return 'assets/icons/social_media/instagram.png';
      case SocialMediaType.website:
        return 'assets/icons/social_media/website.png';
      case SocialMediaType.whatsapp:
        return 'assets/icons/social_media/whatsapp.png';
    }
  }

  String get helperText {
    switch (this) {
      case SocialMediaType.youtube:
        return 'Ссылка на YouTube';
      case SocialMediaType.facebook:
        return 'Ссылка на Facebook';
      case SocialMediaType.instagram:
        return 'Ссылка на Instagram';
      case SocialMediaType.website:
        return 'Ссылка на Веб-сайт';
      case SocialMediaType.whatsapp:
        return 'Номер WhatsApp';
    }
  }

  String get errorText {
    switch (this) {
      case SocialMediaType.youtube:
        return 'Нужна прямая сылка на YouTube';
      case SocialMediaType.facebook:
        return 'Нужна прямая сылка на Facebook';
      case SocialMediaType.instagram:
        return 'Нужна прямая сылка на Instagram';
      case SocialMediaType.website:
        return 'Нужна прямая сылка на Веб-сайт';
      case SocialMediaType.whatsapp:
        return 'Нужен прямой номер от WhatsApp';
    }
  }
}