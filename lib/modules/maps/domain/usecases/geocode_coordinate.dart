import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/maps/domain/repositories/map_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:latlong/latlong.dart';
import 'package:geocoding/geocoding.dart';

class GeocodeCoordinate extends UseCase<List<Placemark>, LatLng> {
  final MapRepository repository;

  GeocodeCoordinate({
    @required this.repository,
  });

  @override
  Future<Either<Failure, List<Placemark>>> call(LatLng params) async {
    return repository.getPlaceMarksFromCoordinate(params);
  }
}
