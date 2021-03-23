import 'package:flutter/material.dart';

import '../../../../core/widgets/independent/buttons/gradient_main_button.dart';
import '../../domain/entities/social_media.dart';
import '../widgets/social_media_item.dart';

abstract class SocialMediaPickerDelegate {
  void didFillSocialMedia (SocialMedia socialMedia);
}

class SocialMediaScreen extends StatefulWidget {
  
  static Route route({
    @required SocialMediaPickerDelegate delegate,
    @required SocialMedia socialMedia
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => SocialMediaScreen(
        socialMedia: socialMedia,
        delegate: delegate,
      ));
  }

  final SocialMedia socialMedia;
  final SocialMediaPickerDelegate delegate;

  SocialMediaScreen({
    @required this.socialMedia,
    @required this.delegate
  });

  @override
  _SocialMediaScreenState createState() => _SocialMediaScreenState();
}

class _SocialMediaScreenState extends State<SocialMediaScreen> {

  final _formKey = GlobalKey<FormState>();

  Map<SocialMediaType, TextEditingController> textControllers = {};

  @override
  void initState() {
    _handleTextControllers();
    super.initState();
  }

  @override
  void dispose() {
    _disposeTextControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Сайт и соцсети"),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...SocialMediaType.values.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                    child: SocialMediaItem(
                      socialMediaType: e,
                      textEditingController: textControllers[e]
                    ),
                  )
                ).toList(),
                _buildSaveContainer()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveContainer () {
    return Container(
      color: Color.fromRGBO(236, 233, 248, 1),
      padding: const EdgeInsets.only(top: 30, bottom: 60, left: 16, right: 16),
      child: ActionButton(
        text: 'Сохранить',
        onTap: () {
          if (_formKey.currentState.validate()) {
            widget.delegate.didFillSocialMedia(_buildSocialMedia());
            Navigator.of(context).pop();
          }
        }
      )
    );
  }

  void _handleTextControllers () {
    SocialMediaType.values.forEach((e) { 
      textControllers[e] = TextEditingController();
      textControllers[e].text = e.getValue(widget.socialMedia);
    });
  }

  void _disposeTextControllers () {
    SocialMediaType.values.forEach((e) { 
      textControllers[e].dispose();
    });
  }

  SocialMedia _buildSocialMedia () {
    return SocialMedia(
      websiteLink: textControllers[SocialMediaType.website].text,
      facebookLink: textControllers[SocialMediaType.facebook].text,
      instagramLink: textControllers[SocialMediaType.instagram].text,
      youtubeLink: textControllers[SocialMediaType.website].text,
      whatsappNumber: textControllers[SocialMediaType.whatsapp].text
    );
  }
}

