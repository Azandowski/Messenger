import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/core/config/language.dart';
import 'package:messenger_mobile/core/error/failures.dart';

class Translator {
  final http.Client client;

  Translator({ @required this.client });

  Future<Either<Failure, TranslationResponse>> translateText ({
    @required String originalText,
    @required String langCode
  }) async {
    try {
      http.Response response = await client.post(
        Uri.parse("https://translate.api.cloud.yandex.net/translate/v2/translate"),
        body: json.encode({
          "folder_id": "b1gkq1ghkfika97l9en2",
          'texts': [originalText],
          'targetLanguageCode': langCode
        }),
        headers: {
          'Authorization': 'Api-Key AQVN1vzRDlStWsG4chCPOYI3cZAwXBIIJBS2warl'
        }
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        List translations = json.decode(response.body)['translations'] ?? [];

        if (translations.length != 0) {
          return Right(TranslationResponse.fromJson(translations[0]));
        } else {
          return Left(ServerFailure(message: 'Not Found'));
        }
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Not Found'));
    }
  }
}



class TranslationResponse {
  final String text;
  final String detectedLanguage;

  TranslationResponse({
    @required this.text,
    @required this.detectedLanguage
  });

  factory TranslationResponse.fromJson (Map<String, dynamic> json) {
    String _detectedLanguage = '';
    var langIndex = ApplicationLanguage.values.indexOf(json['detectedLanguageCode']);
    
    // Detecting language
    if (langIndex == -1) {
      _detectedLanguage = json['detectedLanguageCode'];
    } else {
      _detectedLanguage = ApplicationLanguage.values[langIndex].name;
    }


    return TranslationResponse(
      detectedLanguage: _detectedLanguage,
      text: json['text']
    );
  }
}