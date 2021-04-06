import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/maps/data/models/place_model.dart';
import 'package:messenger_mobile/modules/maps/domain/entities/place.dart';

class PlaceResponse {
  final List<Place> items;

  PlaceResponse({
    @required this.items
  });

  factory PlaceResponse.fromJson (Map<String, dynamic> json) {
    return PlaceResponse(
      items: (json['results']['items'] ?? []).map((e) => PlaceModel.fromJson(e)).toList().cast<Place>()
    );
  }
}