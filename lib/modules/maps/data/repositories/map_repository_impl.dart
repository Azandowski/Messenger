import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding_platform_interface/src/models/placemark.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/modules/maps/data/datasources/local_map_datasource.dart';
import 'package:messenger_mobile/modules/maps/data/datasources/remote_map_datasource.dart';
import 'package:messenger_mobile/modules/maps/domain/entities/place.dart';
import 'package:messenger_mobile/modules/maps/domain/repositories/map_repository.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/params.dart';
import 'package:permission_handler/permission_handler.dart';

class MapRepositoryImpl extends MapRepository {
  
  final LocalMapDatasource datasource;
  final RemoteMapDataSource remoteMapDataSource;
  final NetworkInfo networkInfo;

  MapRepositoryImpl({
    @required this.datasource,
    @required this.remoteMapDataSource,
    @required this.networkInfo
  });

  @override
  Future<Either<GeolocationFailure, Position>> getCurrentPosition() async {
    bool isServiceEnabled = await datasource.isLocationEnabled();

    if (!isServiceEnabled) {
      return Left(GeolocationFailure(
        LocationFailure.locationDisabled
      ));
    } 

    PermissionStatus permissionStatus = await datasource.checkPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await datasource.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        await Geolocator.openAppSettings();
        return Left(GeolocationFailure(
          LocationFailure.permissionDenied
        ));
      }
    }

    return Right(await datasource.getCurrentPosition());
  }

  @override
  Future<Either<Failure, List<Place>>> getNearbyPlaces(LatLng currentPosition) async {
    if (await networkInfo.isConnected) {
      try {
        var placesResponse = await remoteMapDataSource.getNearbyPlaces(currentPosition);
        return Right(placesResponse.items);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<Place>>> searchPlaces(SearchPlacesParams params) async {
    if (await networkInfo.isConnected) {
      try {
        var placesResponse = await remoteMapDataSource.searchPlaces(params.queryText, params.currentPosition);
        return Right(placesResponse.items);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<Placemark>>> getPlaceMarksFromCoordinate(LatLng coordinate) async { 
    if (await networkInfo.isConnected) {
      try {
        var placemarks = await datasource.geocodeCoordinate(coordinate);
        return Right(placemarks);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}