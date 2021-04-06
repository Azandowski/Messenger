import 'package:messenger_mobile/core/config/language.dart';
import 'package:messenger_mobile/core/services/localdb/app_database.dart';
import 'package:messenger_mobile/modules/chat/data/models/translation_response.dart';
import 'package:sembast/sembast.dart';

abstract class LocalChatDataSource {
  Future<TranslationResponse> getMessageTranslation (int messageID, ApplicationLanguage language);
  Future<void> saveMessageTranslation (int messageID, TranslationResponse response, ApplicationLanguage language);
}

class LocalChatDataSourceImpl extends LocalChatDataSource {
  Future<Database> get _localDb async => await AppDatabase.instance.database;
  final _translationsFolder = intMapStoreFactory.store('translations');

  @override
  Future<TranslationResponse> getMessageTranslation(int messageID, ApplicationLanguage language) async {
    Finder finder = Finder(
      filter: Filter.byKey(messageID)
    );

    List<RecordSnapshot> data = await _translationsFolder.find(await _localDb, finder: finder);

    var el =  data.firstWhere((e) => 
      TranslationResponse.fromJson(e.value).translatedToLanguage == language, orElse: () => null);

    if (el == null || el.value == null) {
      return null;
    } else {
      return TranslationResponse.fromJson(el.value);
    }
  }

  @override
  Future<void> saveMessageTranslation(
    int messageID, 
    TranslationResponse response,
    ApplicationLanguage language
  ) async {
    var recordJSON = response.toJson();
    recordJSON['translated_to'] = language.yandexTrKey;

    _translationsFolder.record(messageID).put(
      await _localDb, 
      recordJSON
    );
  }
}

// * * Structure of saved item

///  key: int 
///  body: {
///     "text": "Привет",
///     "detectedLanguageCode": "en"
///  }
