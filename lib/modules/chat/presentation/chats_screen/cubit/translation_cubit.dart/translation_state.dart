part of 'translation_cubit.dart';


abstract class TranslationState extends Equatable {
  @override
  List<Object> get props => [];
}

class EmptyTranslationState extends TranslationState {}

class TranslatedState extends TranslationState {
  final TranslationResponse translationResponse;
  

  TranslatedState({
    @required this.translationResponse
  });

  @override
  List<Object> get props => [
    translationResponse
  ];
}

class TranslatingState extends TranslationState {}