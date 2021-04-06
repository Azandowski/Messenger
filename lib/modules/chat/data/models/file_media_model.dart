import '../../../../core/extensions/string_extension.dart';
import '../../domain/entities/file_media.dart';
import '../../presentation/chat_details/widgets/chat_media_block.dart';
class FileMediaModel extends FileMedia{

  final int id;
  final String url;
  final TypeMedia type;
  final int userId;
  final Duration maxDuration;

  FileMediaModel({
    this.id,
    this.maxDuration,
    this.type,
    this.url,
    this.userId,
  }) : super(
    id: id,
    url: url,
    type: type,
    userId: userId,
    maxDuration: maxDuration
  );

  factory FileMediaModel.fromJson(Map<String, dynamic> json) {
   return FileMediaModel(
    id: json['id'],
    url: json['full_link'],
    type: (json['type'] as String).getMediaType,
    userId: json['user_id'],
    maxDuration: json['duration'] != null ? Duration(seconds: json['duration']) : null,
   );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['file'] = this.url;
    data['type'] = this.type.string;
    data['user_id'] = this.userId;
    return data;
  }

}