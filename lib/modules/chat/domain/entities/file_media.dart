import 'package:equatable/equatable.dart';

import '../../presentation/chat_details/widgets/chat_media_block.dart';

class FileMedia extends Equatable {
  final int id;
  final String url;
  final TypeMedia type;
  final int userId;
  final Duration maxDuration;


  FileMedia(
    {
      this.id,
      this.url,
      this.type,
      this.userId,
      this.maxDuration,
    }
  );

  @override
  List<Object> get props => [id, url, type, userId, maxDuration];
}