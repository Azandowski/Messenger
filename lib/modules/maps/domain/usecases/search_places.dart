import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/maps/domain/entities/place.dart';
import 'package:messenger_mobile/modules/maps/domain/repositories/map_repository.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/params.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';


class SearchPlaces extends UseCase<List<Place>, SearchPlacesParams>  {

  final MapRepository repository;

  SearchPlaces({
    @required this.repository,
  });

  @override
  Future<Either<Failure, List<Place>>> call(SearchPlacesParams params) {
    return repository.searchPlaces(params);
  }
}