import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chat/data/models/translation_response.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';

class TranslateMessage implements UseCase<TranslationResponse, TranslateMessageParams> {
  final ChatRepository repository;

  TranslateMessage({
    @required this.repository
  });

  @override
  Future<Either<Failure, TranslationResponse>> call(TranslateMessageParams params) {
    return repository.translateMessage(params.messageID, params.originalText, params.applicationLanguage);
  }
}