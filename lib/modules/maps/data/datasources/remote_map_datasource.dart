import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/maps/data/models/place_response.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/modules/maps/domain/entities/place.dart';
import '../../../../core/utils/http_response_extension.dart';
import 'here_endpoint.dart';


abstract class RemoteMapDataSource {
  Future<PlaceResponse> getNearbyPlaces (LatLng currentPosition);
  Future<PlaceResponse> searchPlaces (String queryText, LatLng currentPosition);
}

class RemoteMapDataSourceImpl extends RemoteMapDataSource {
  
  final http.Client client;
  final String _hereAPIKey = 'GLfkTqRAR2Sz2Wtrxyp5AhF4IarjNdHyFHlGvu1rMaU';

  RemoteMapDataSourceImpl({
    @required this.client
  });

  @override
  Future<PlaceResponse> getNearbyPlaces(LatLng currentPosition) async {
    http.Response response = await client.get(
      HereEndpoints.getNearbyPlaces.buildURL(
        queryParameters: {
          'apiKey': _hereAPIKey,
          'at': '${currentPosition.latitude},${currentPosition.longitude};'
        }
      ),
      headers: new Map<String, String>.from(HereEndpoints.getNearbyPlaces.headers)
    );

    if (response.isSuccess) {
      return PlaceResponse.fromJson(json.decode(response.body.toString()));
    } else {
      throw ServerFailure(message: response.body.toString());
    }
  }

  @override
  Future<PlaceResponse> searchPlaces(String queryText, LatLng currentPosition) async {
    http.Response response = await client.get(
      HereEndpoints.searchPlaces.buildURL(
        queryParameters: {
          'apiKey': _hereAPIKey,
          'at': '${currentPosition.latitude},${currentPosition.longitude};',
          'q': queryText
        }
      ),
      headers: new Map<String, String>.from(HereEndpoints.searchPlaces.headers)
    );

    if (response.isSuccess) {
      return PlaceResponse.fromJson(json.decode(response.body.toString()));
    } else {
      throw ServerFailure(message: response.body.toString());
    }
  }
}