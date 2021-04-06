import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/config/language.dart';

class TranslationResponse extends Equatable {
  final String text;
  final String detectedLanguage;
  final String detectedLanguageUnformatted;
  final ApplicationLanguage translatedToLanguage;

  TranslationResponse({
    @required this.text,
    @required this.detectedLanguage,
    this.detectedLanguageUnformatted,
    this.translatedToLanguage
  });

  factory TranslationResponse.fromJson (Map<String, dynamic> json) {
    String _detectedLanguage = '';
    var langIndex = ApplicationLanguage.values.indexWhere((e) => e.yandexTrKey == json['detectedLanguageCode']);
    
    // Detecting language
    if (langIndex == -1) {
      _detectedLanguage = json['detectedLanguageCode'];
    } else {
      _detectedLanguage = ApplicationLanguage.values[langIndex].name;
    }

    return TranslationResponse(
      detectedLanguage: _detectedLanguage,
      text: json['text'],
      detectedLanguageUnformatted: json['detectedLanguageCode'],
      translatedToLanguage: ApplicationLanguage.values
        .firstWhere((e) => e.yandexTrKey == json['translated_to'])
    );
  }
  
  Map<String, dynamic> toJson () {
    return {
      'detectedLanguageCode': detectedLanguageUnformatted,
      'text': text,
      'translated_to': translatedToLanguage.yandexTrKey
    };
  }

  @override
  List<Object> get props => [
    text, 
    detectedLanguageUnformatted, 
    detectedLanguage, 
    translatedToLanguage
  ];
}