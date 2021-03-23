import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';


class SearchPlacesParams {
  final LatLng currentPosition;
  final String queryText;

  SearchPlacesParams({
    @required this.currentPosition,
    @required this.queryText
  });
}