import 'package:messenger_mobile/modules/maps/domain/entities/place.dart';
import 'package:latlong/latlong.dart';

class PlaceModel extends Place {
  final LatLng position;
  final String title;
  final num distance;
  final String street;

  PlaceModel({this.position, this.title, this.distance, this.street})
      : super(
            position: position,
            distance: distance,
            street: street,
            title: title);

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
        position: LatLng(json['position'][0], json['position'][1]),
        distance: json['distance'],
        street: ((json['vicinity'] ?? '') as String).removeAllHtmlTags(),
        title: json['title']);
  }
}

extension StringPlaceHereExtension on String {
  String removeAllHtmlTags() {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return this.replaceAll(exp, ' ');
  }
}
