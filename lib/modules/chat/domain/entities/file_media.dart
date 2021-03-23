import 'package:equatable/equatable.dart';

import '../../presentation/chat_details/widgets/chat_media_block.dart';

class FileMedia extends Equatable {
  final int id;
  final String url;
  final MediaType type;
  final int userId;


  FileMedia(
    {
      this.id,
      this.url,
      this.type,
      this.userId,
    }
  );

  @override
  List<Object> get props => [id, url, type, userId,];
}