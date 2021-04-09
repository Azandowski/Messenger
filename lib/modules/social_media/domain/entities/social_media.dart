import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class SocialMedia extends Equatable {
  final String facebookLink;
  final String instagramLink;
  final String websiteLink;
  final String youtubeLink;
  final String whatsappNumber;

  SocialMedia(
      {@required this.facebookLink,
      @required this.instagramLink,
      @required this.websiteLink,
      @required this.youtubeLink,
      @required this.whatsappNumber});

  @override
  List<Object> get props =>
      [facebookLink, instagramLink, websiteLink, youtubeLink, whatsappNumber];

  Map<String, dynamic> toJson() {
    return {
      'facebook': facebookLink,
      'site': websiteLink,
      'youtube': youtubeLink,
      'instagram': instagramLink,
      'whatsapp': whatsappNumber
    };
  }
}

enum SocialMediaType { website, instagram, facebook, youtube, whatsapp }

extension SocialMediaTypeExtension on SocialMediaType {
  String getValue(SocialMedia socialMedia) {
    switch (this) {
      case SocialMediaType.website:
        return socialMedia?.websiteLink ?? '';
      case SocialMediaType.instagram:
        return socialMedia?.instagramLink ?? '';
      case SocialMediaType.youtube:
        return socialMedia?.youtubeLink ?? '';
      case SocialMediaType.facebook:
        return socialMedia?.facebookLink ?? '';
      case SocialMediaType.whatsapp:
        return socialMedia?.whatsappNumber ?? '';
      default:
        return '';
    }
  }
}
