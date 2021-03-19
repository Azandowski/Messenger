import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:messenger_mobile/modules/maps/domain/repositories/map_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';


class GetCurrentLocation extends UseCase<Position, NoParams>  {

  final MapRepository repository;

  GetCurrentLocation({
    @required this.repository,
  });

  @override
  Future<Either<GeolocationFailure, Position>> call(NoParams params) async {
    return await repository.getCurrentPosition();
  }
}