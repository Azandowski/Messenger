import 'package:flutter_test/flutter_test.dart';

import '../../../../variables.dart';

void main() {
  test('shoul return expected json from SocialMedia', () {
    final expected = {
      "facebook": "facebookLink",
      "site": "websiteLink",
      "youtube": "youtubeLink",
      "whatsapp": "whatsappNumber",
      "instagram": "instagramLink"
    };
    final actual = tSocialMedia.toJson();

    expect(actual, equals(expected));
  });
}
