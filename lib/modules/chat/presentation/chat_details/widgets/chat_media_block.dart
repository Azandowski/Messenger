import 'package:flutter/material.dart';

import '../../../domain/entities/chat_detailed.dart';
import 'divider_wrapper.dart';

class ChatMediaBlock extends StatelessWidget {
  
  final MediaStats media;
  
  ChatMediaBlock({
    @required this.media
  });

  @override
  Widget build(BuildContext context) {
    return DividerWrapper(
      children: [TypeMedia.media, TypeMedia.documents, TypeMedia.audio].map(
        (e) => ListTile(
          leading: Image(
            image: AssetImage(e.imageAssetPath),
            width: 35,
            height: 35
          ),
          title: Text(e.title),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${e.getCountFrom(media)}',
                style: TextStyle(color: Colors.grey[400]),
              ),
              SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.grey[400])
            ],
          ),
        )
      ).toList(),
    );
  }
}

enum TypeMedia { media, documents, audio, undefined, image, video }

extension MediaTypeUIExtension on TypeMedia {
  String get title {
    switch (this) {
      case TypeMedia.media:
        return 'Медиа';
      case TypeMedia.documents:
        return 'Документы';
      case TypeMedia.audio:
        return 'Аудио';
      default:
        return '';
    }
  }

  String get string {
    switch (this) {
      case TypeMedia.audio:
        return 'audio';
      case TypeMedia.documents:
        return 'documents';
      case TypeMedia.image:
        return 'image';
      default:
        return '';
    }
  }

  String get imageAssetPath {
    switch (this) {
      case TypeMedia.media:
        return 'assets/icons/media.png';
      case TypeMedia.documents:
        return 'assets/icons/documents.png';
      case TypeMedia.audio:
        return 'assets/icons/audio.png';
      default:
        return '';
    }
  }

  int getCountFrom (MediaStats stats) {
    switch (this) {
      case TypeMedia.media:
        return stats.mediaCount;
      case TypeMedia.documents:
        return stats.documentCount;
      case TypeMedia.audio:
        return stats.audioCount;
      default:
        return 0;
    }
  }
}