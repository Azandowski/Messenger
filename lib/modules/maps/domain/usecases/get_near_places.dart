import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/maps/domain/entities/place.dart';
import 'package:messenger_mobile/modules/maps/domain/repositories/map_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:latlong/latlong.dart';


class GetNearbyPlaces extends UseCase<List<Place>, LatLng>  {

  final MapRepository repository;

  GetNearbyPlaces({
    @required this.repository,
  });

  @override
  Future<Either<Failure, List<Place>>> call(LatLng params) {
    return repository.getNearbyPlaces(params);
  }
}