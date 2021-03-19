import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/maps/data/datasources/local_map_datasource.dart';
import 'package:latlong/latlong.dart';
import 'package:messenger_mobile/modules/maps/domain/entities/place.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/params.dart';
import 'package:geocoding/geocoding.dart';

abstract class MapRepository {
  Future<Either<GeolocationFailure, Position>> getCurrentPosition();
  Future<Either<Failure, List<Place>>> getNearbyPlaces (LatLng currentPosition);
  Future<Either<Failure, List<Place>>> searchPlaces (SearchPlacesParams params);
  Future<Either<Failure, List<Placemark>>> getPlaceMarksFromCoordinate (LatLng coordinate);
}