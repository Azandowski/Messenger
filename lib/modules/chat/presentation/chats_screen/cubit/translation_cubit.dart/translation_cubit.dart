import 'package:messenger_mobile/app/application.dart';
import 'package:messenger_mobile/modules/chat/data/models/translation_response.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/translate_message.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:equatable/equatable.dart';
part 'translation_state.dart';

class TranslationCubit extends Cubit<TranslationState> {
  final ChatRepository chatRepository;
  TranslateMessage _translateMessage;
  int idOfMessage;

  TranslationCubit(
    this.chatRepository, {
      @required int messageID
    }) : super(EmptyTranslationState()) {
    idOfMessage = messageID;
    _translateMessage = TranslateMessage(repository: chatRepository);
    init(messageID);
  }
  
  Future<void> init (int messageID) async {
    var oldTranslation = await chatRepository.getOldTranslation(
      messageID,
      sl<Application>().appLanguage
    );
    if (oldTranslation != null) {
      oldTranslation.fold((l) => print(l), (response) {
        if (response != null) {
          emit(TranslatedState(
            translationResponse: response
          ));
        }
      });
    } 
  }

  Future<void> resetTranslation (int messageID) async {
    emit(EmptyTranslationState());
    var oldTranslation = await chatRepository.getOldTranslation(
      messageID,
      sl<Application>().appLanguage
    );

    if (oldTranslation != null) {
      oldTranslation.fold((l) => print(l), (response) {
        if (response != null) {
          emit(TranslatedState(
            translationResponse: response
          ));
        }
      });
    } 

    idOfMessage = messageID;
  }

  Future<void> translateMessage ({
    @required String text,
    @required int messageID
  }) async {
    emit(TranslatingState());

    var response = await _translateMessage(TranslateMessageParams(
      messageID: messageID, 
      originalText: text, 
      applicationLanguage: sl<Application>().appLanguage
    ));

    response.fold((failure) => print(failure), 
      (translationResopnse) => emit(TranslatedState(
        translationResponse: translationResopnse
    )));
  }

  @override
  Future<void> close() {
    print('closing');
    return super.close();
  }
}