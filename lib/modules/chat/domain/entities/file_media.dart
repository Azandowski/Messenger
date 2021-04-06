import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../presentation/chat_details/widgets/chat_media_block.dart';

class FileMedia extends Equatable {
  final int id;
  final String url;
  final TypeMedia type;
  final bool isLocal;
  final int userId;
  final Duration maxDuration;
  final List<Uint8List> memoryPhotos;

  FileMedia(
    {
      this.id,
      this.isLocal = false,
      this.url,
      this.type,
      this.userId,
      this.maxDuration,
      this.memoryPhotos,
    }
  );

  @override
  List<Object> get props => [id, url, type, userId, maxDuration, memoryPhotos, isLocal];
}