import '../../domain/entities/social_media.dart';
import 'package:easy_localization/easy_localization.dart';

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
        return 'link_to'.tr(namedArgs: {
          'service': 'YouTube'
        });
      case SocialMediaType.facebook:
        return 'link_to'.tr(namedArgs: {
          'service': 'Facebook'
        });
      case SocialMediaType.instagram:
        return 'link_to'.tr(namedArgs: {
          'service': 'Instagram'
        });
      case SocialMediaType.website:
        return 'link_to'.tr(namedArgs: {
          'service': 'website'.tr()
        });
      case SocialMediaType.whatsapp:
        return 'whatsapp_number'.tr();
    }
  }

  String get errorText {
    switch (this) {
      case SocialMediaType.youtube:
        return 'link_error'.tr(namedArgs: {
          'service': 'YouTube'
        });
      case SocialMediaType.facebook:
        return 'link_error'.tr(namedArgs: {
          'service': 'Facebook'
        });
      case SocialMediaType.instagram:
        return 'link_error'.tr(namedArgs: {
          'service': 'Instagram'
        });
      case SocialMediaType.website:
        return 'link_error'.tr(namedArgs: {
          'service': 'website'.tr()
        });
      case SocialMediaType.whatsapp:
        return 'whatsapp_number_error'.tr();
    }
  }
}