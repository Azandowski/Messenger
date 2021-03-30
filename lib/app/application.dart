import 'package:messenger_mobile/core/config/language.dart';
import '../modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';

class Application {
  final GlobalKey<NavigatorState> navKey = new GlobalKey<NavigatorState>();
  ApplicationLanguage _language = ApplicationLanguage.russian;
  ApplicationLanguage get appLanguage => _language;

  void changeAppLanguage (Locale locale) {
    _language = ApplicationLanguage.values
      .firstWhere(
        (e) => e.localeCode.languageCode == locale.languageCode, 
        orElse: () => ApplicationLanguage.russian
      );
  }
}