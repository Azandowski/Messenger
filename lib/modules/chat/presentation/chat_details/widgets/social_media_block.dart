import '../../chats_screen/pages/chat_screen_import.dart';
import '../../../../social_media/domain/entities/social_media.dart';
import '../../../../social_media/presentation/helpers/ui_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaBlock extends StatelessWidget {
  final bool canEdit;
  final SocialMedia socialMedia;
  final Function() onAddPressed;
  final Function(SocialMediaType) onTapSocialMedia;

  SocialMediaBlock({
    @required this.socialMedia,
    @required this.onAddPressed,
    @required this.onTapSocialMedia,
    @required this.canEdit
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Соцсети и сайт',
                  style: AppFontStyles.black16,
                ),
                SizedBox(height: 4),
                if (canEdit)
                  Text(
                    'Вы можете добавить ссылки на соцсети и сайт',
                    style: AppFontStyles.grey14w400,
                  ),
              ],
            ),
          ),
          SocialMediaView(
            socialMedia: socialMedia,
            onTapSocialMedia: onTapSocialMedia,
          ),
          if (canEdit)
            InkWell(
              onTap: onAddPressed,
              child: ListTile(
                title: Text('Добавление и управление'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            )
        ],
      ),
    );
  }
}


class SocialMediaView extends StatelessWidget {
  final SocialMedia socialMedia;
  final Function(SocialMediaType) onTapSocialMedia;

  SocialMediaView({
    @required this.socialMedia,
    @required this.onTapSocialMedia
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (socialMedia?.websiteLink != null && socialMedia?.websiteLink != '')
            _buildField(
              assetPath: 'assets/icons/social_media/website.png',
              value: socialMedia.websiteLink
            ),
          _buildSocialMedia()
        ]
      ),
    );
  }


  Widget _buildField ({
    @required String assetPath,
    @required String value
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/social_media/website.png',
            width: 16,
            height: 16,
          ),
          SizedBox(
            width: 10
          ),
          Text(value, style: AppFontStyles.black14w400,)
        ],
      ),
    );
  }

  Widget _buildSocialMedia () {
    var socialMediaTypes = SocialMediaType.values
      .where((e) => e != SocialMediaType.website && e.getValue(socialMedia) != '')
      .toList();

    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: socialMediaTypes
          .map((e) => Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 4),
            child: InkWell(
              onTap: () {
                onTapSocialMedia(e);
              },
              child: Image.asset(
                e.assetImagePath,
                width: 35,
                height: 35,
              ),
            ),
          )).toList()
      ),
    );
  }
}