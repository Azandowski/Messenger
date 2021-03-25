import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/maps/data/datasources/local_map_datasource.dart';
import 'package:messenger_mobile/modules/maps/domain/entities/place.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/geocode_coordinate.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/get_current_position.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/get_near_places.dart';
import 'package:latlong/latlong.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/search_places.dart';
import 'package:messenger_mobile/modules/maps/presentation/pages/map_screen.dart';
import '../pages/map_screen_helper.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  
  final GetCurrentLocation getCurrentLocation;
  final GetNearbyPlaces getNearbyPlaces;
  final SearchPlaces searchPlaces;
  final GeocodeCoordinate geocodeCoordinate;

  MapCubit({
    @required this.getCurrentLocation,
    @required this.getNearbyPlaces,
    @required this.searchPlaces,
    @required this.geocodeCoordinate
  }) : super(MapInitial());

  // MARK: - Requests

  Future<void> getCurrentUserPosition ({
    bool loadNearPlaces
  }) async {
    var response = await getCurrentLocation(NoParams());
    response.fold((failure) => emit(
      MapError(
        locationFailure: failure.failure,
        currentUserPosition: state.currentUserPosition,
        places: state.places
      )
    ), (position) {
      emit(MapInitial(
        currentUserPosition: position,
        selectedPlace: state.selectedPlace,
        places: state.places
      ));

      if (loadNearPlaces) {
        getPlacesNear();
      }
    }); 
  }


  Future<void> getPlacesNear ({LatLng position}) async {
    emit(MapLoading(
      currentUserPosition: state.currentUserPosition,
      selectedPlace: state.selectedPlace,
      places: state.places,
      isPlacesLoading: true
    ));

    var currentPosition = state.currentUserPosition;
    var response = await getNearbyPlaces(position ?? LatLng(
      currentPosition.latitude, currentPosition.longitude
    ));

    response.fold((failure) => emit(
      MapError(
        errorMessage: failure.message,
        currentUserPosition: state.currentUserPosition,
        places: state.places
      )
    ), (places) => emit(
      MapInitial(
        currentUserPosition: state.currentUserPosition,
        selectedPlace: state.selectedPlace,
        places: places
      )
    ));
  }

  Future<void> findPlaces (String queryText) async {
    emit(MapLoading(
      currentUserPosition: state.currentUserPosition,
      selectedPlace: state.selectedPlace,
      places: state.places,
      isPlacesLoading: true
    ));

    var currentPosition = state.currentUserPosition;
    var response = await searchPlaces(SearchPlacesParams(
      currentPosition: LatLng(currentPosition.latitude, currentPosition.longitude),
      queryText: queryText
    ));

    response.fold((failure) => emit(
      MapError(
        errorMessage: failure.message,
        currentUserPosition: state.currentUserPosition,
        places: state.places
      )
    ), (places) => emit(
      MapInitial(
        currentUserPosition: state.currentUserPosition,
        selectedPlace: state.selectedPlace,
        places: places
      )
    ));
  }

  void showLoading () {
    emit(MapLoading(
      currentUserPosition: state.currentUserPosition,
      selectedPlace: state.selectedPlace,
      places: state.places,
      isPlacesLoading: true
    ));
  }

  void didSelectPlace (Place selectedPlace) {
    emit(MapInitial(
      places: state.places,
      currentUserPosition: state.currentUserPosition,
      selectedPlace: selectedPlace
    ));
  }

  Future<void> didSelectPosition (LatLng position) async {
    
    if (position == state.currentUserPosition?.getLatLng) {
      emit(MapInitial(
        places: state.places,
        currentUserPosition: state.currentUserPosition,
      ));
    } else if (position != state.selectedPlace?.position) {
      emit(MapLoading(
        currentUserPosition: state.currentUserPosition,
        selectedPlace: state.selectedPlace,
        places: state.places,
        isPlacesLoading: false,
        isProcessing: true
      ));

      var response = await geocodeCoordinate(position);
      response.fold((failure) => emit(
        MapError(
          errorMessage: failure.message,
          currentUserPosition: state.currentUserPosition,
          places: state.places
        )
      ), (placemarks) {
        if (placemarks.length != 0) {
          var placemark = placemarks[0];
          Place place = Place(
            title: placemark.name,
            position: position,
            street: placemark.name
          );

          getPlacesNear(position: position);

          emit(MapInitial(
            places: state.places,
            currentUserPosition: state.currentUserPosition,
            selectedPlace: place
          ));
        } else {
          emit(MapError(
            errorMessage: 'Не удалось найти',
            places: state.places,
            currentUserPosition: state.currentUserPosition,
            selectedPlace: state.selectedPlace
          ));
        }
      });
    }
  }


  Future<PositionAddress> getMapPosition (LatLng position) async {
    emit(MapLoading(
      currentUserPosition: state.currentUserPosition,
      selectedPlace: state.selectedPlace,
      places: state.places,
      isPlacesLoading: false,
      isProcessing: true
    ));

    var response = await geocodeCoordinate(position);
    emit(MapInitial(
      currentUserPosition: state.currentUserPosition,
      selectedPlace: state.selectedPlace,
      places: state.places,
    ));
    
    return response.fold((failure) {
      emit(
        MapError(
          errorMessage: failure.message,
          currentUserPosition: state.currentUserPosition,
          places: state.places
        )
      );
    }, (placemarks) {
      if (placemarks.length != 0) {
        var placemark = placemarks[0];

        return PositionAddress(
          position: position,
          description: placemark.name
        );
      } else {
        emit(MapError(
          errorMessage: 'Не удалось найти',
          places: state.places,
          currentUserPosition: state.currentUserPosition,
          selectedPlace: state.selectedPlace
        ));
      }
    });
  }
}
