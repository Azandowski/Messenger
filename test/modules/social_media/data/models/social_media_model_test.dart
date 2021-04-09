import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/social_media/data/models/social_media_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

void main() {
  test('shold return expected SocialMediaModel form json', () {
    final actual = SocialMediaModel.fromJson(
      jsonDecode(fixture('social_media_model.json')),
    );

    expect(actual, equals(tSocialMediaModel));
  });
}
