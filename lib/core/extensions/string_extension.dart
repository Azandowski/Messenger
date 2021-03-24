import '../../modules/chat/presentation/chat_details/widgets/chat_media_block.dart';

extension StringExtension on String {
  MediaType get getMediaType {
    switch (this) {
      case 'audio':
      return MediaType.audio;
      default:
      return MediaType.undefined;
    }
  }
}