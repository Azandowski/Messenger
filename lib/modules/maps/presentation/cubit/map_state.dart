part of 'map_cubit.dart';

abstract class MapState extends Equatable {
  final Position currentUserPosition;
  final Place selectedPlace;
  final List<Place> places;

  const MapState({
    @required this.currentUserPosition,
    this.selectedPlace,
    this.places
  });

  @override
  List<Object> get props => [
    currentUserPosition,
    selectedPlace,
    places
  ];
}

class MapInitial extends MapState {
  final Position currentUserPosition;
  final Place selectedPlace;
  final List<Place> places;

  MapInitial({
    this.currentUserPosition,
    this.selectedPlace,
    this.places
  }) : super(
    currentUserPosition: currentUserPosition,
    selectedPlace: selectedPlace,
    places: places
  );

  @override
  List<Object> get props => [
    currentUserPosition,
    selectedPlace,
    places
  ];
}


class MapLoading extends MapState {
  final bool isPlacesLoading;
  final bool isProcessing;
  final Position currentUserPosition;
  final Place selectedPlace;
  final List<Place> places;

  MapLoading({
    this.currentUserPosition,
    this.selectedPlace,
    this.places,
    this.isPlacesLoading,
    this.isProcessing
  }) : super(
    currentUserPosition: currentUserPosition,
    selectedPlace: selectedPlace,
    places: places
  );

  @override
  List<Object> get props => [
    currentUserPosition,
    selectedPlace,
    places,
    isPlacesLoading,
    isProcessing
  ];
}

class MapError extends MapState {
  final Position currentUserPosition;
  final LocationFailure locationFailure;  
  final Place selectedPlace;
  final List<Place> places;
  final String errorMessage;

  MapError({
    this.currentUserPosition,
    this.locationFailure,
    this.selectedPlace,
    this.places,
    this.errorMessage
  }) : super(
    currentUserPosition: currentUserPosition,
    selectedPlace: selectedPlace,
    places: places
  );

  @override
  List<Object> get props => [
    currentUserPosition,
    locationFailure,
    selectedPlace,
    places,
    errorMessage
  ];
}