import 'package:messenger_mobile/modules/chat/domain/entities/delete_messages.dart';

import '../../modules/chat/presentation/chat_details/widgets/chat_media_block.dart';

extension StringExtension on String {
  TypeMedia get getMediaType {
    switch (this) {
      case 'audio':
      return TypeMedia.audio;
      case 'image':
      return TypeMedia.image;
      case 'video':
      return TypeMedia.video;
      default:
      return TypeMedia.undefined;
    }
  }

  DeleteActionType get getDeleteActionType{
      switch (this) {
        case 'deleteMessageSelf':
          return DeleteActionType.deleteSelf;
        case 'deleteMessage':
          return DeleteActionType.deleteAll;
    } 
  }
}