import '../../domain/entities/social_media.dart';

class SocialMediaModel extends SocialMedia {
  final String facebookLink;
  final String instagramLink;
  final String websiteLink;
  final String youtubeLink;
  final String whatsappNumber;

  SocialMediaModel({
    this.facebookLink,
    this.instagramLink,
    this.websiteLink,
    this.youtubeLink,
    this.whatsappNumber
  }) : super(
    facebookLink: facebookLink,
    instagramLink: instagramLink,
    websiteLink: websiteLink,
    youtubeLink: youtubeLink,
    whatsappNumber: whatsappNumber
  );  

  factory SocialMediaModel.fromJson (Map<String, dynamic> json) {
    return SocialMediaModel(
      facebookLink: json['facebook'],
      websiteLink: json['site'],
      youtubeLink: json['youtube'],
      whatsappNumber: json['whatsapp'],
      instagramLink: json['instagram']
    );
  }
}