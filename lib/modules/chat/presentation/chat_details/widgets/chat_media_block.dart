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
      children: MediaType.values.map(
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

enum MediaType { media, documents, audio }

extension MediaTypeUIExtension on MediaType {
  String get title {
    switch (this) {
      case MediaType.media:
        return 'Медиа';
      case MediaType.documents:
        return 'Документы';
      case MediaType.audio:
        return 'Аудио';
      default:
        return '';
    }
  }

  String get imageAssetPath {
    switch (this) {
      case MediaType.media:
        return 'assets/icons/media.png';
      case MediaType.documents:
        return 'assets/icons/documents.png';
      case MediaType.audio:
        return 'assets/icons/audio.png';
      default:
        return '';
    }
  }

  int getCountFrom (MediaStats stats) {
    switch (this) {
      case MediaType.media:
        return stats.mediaCount;
      case MediaType.documents:
        return stats.documentCount;
      case MediaType.audio:
        return stats.audioCount;
      default:
        return 0;
    }
  }
}