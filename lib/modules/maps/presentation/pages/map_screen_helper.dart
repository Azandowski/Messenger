
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/modules/maps/data/datasources/local_map_datasource.dart';
import 'package:messenger_mobile/modules/maps/data/datasources/remote_map_datasource.dart';
import 'package:messenger_mobile/modules/maps/data/repositories/map_repository_impl.dart';
import 'package:messenger_mobile/modules/maps/domain/entities/map_type.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/geocode_coordinate.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/get_current_position.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/get_near_places.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/search_places.dart';
import 'package:messenger_mobile/modules/maps/presentation/cubit/map_cubit.dart';
import 'package:latlong/latlong.dart';
import '../../../../locator.dart';
import 'map_screen.dart';
import 'package:http/http.dart' as http;


extension MapScreenExtension on MapScreenState {
  void initScreen () {
    final MapRepositoryImpl repository = MapRepositoryImpl(
      datasource: LocalMapDatasourceImpl(),
      remoteMapDataSource: RemoteMapDataSourceImpl(
        client: sl<http.Client>()
      ),
      networkInfo: sl<NetworkInfo>()
    );

    mapCubit = MapCubit(
      getCurrentLocation: GetCurrentLocation(
        repository: repository
      ),
      getNearbyPlaces: GetNearbyPlaces(
        repository: repository
      ),
      searchPlaces: SearchPlaces(
        repository: repository
      ),
      geocodeCoordinate: GeocodeCoordinate(
        repository: repository
      )
    );
    mapCubit.getCurrentUserPosition();
  }


  Marker getCurrentLocationMarker (LatLng position, Function() onPress) {
    return Marker (
      width: 40,
      height: 40,
      point: position,
      builder: (ctx) {
        return GestureDetector(
          onTap: onPress,
          child: Image.asset("assets/images/user_pin.png",)
        );
      }
    );
  }

  Marker selectedPlaceMarker (LatLng position, Function() onPress) {
    return Marker (
      width: 40,
      height: 40,
      point: position,
      builder: (ctx) {
        return GestureDetector(
          onTap: onPress,
          child: Image.asset("assets/icons/pin.png",)
        );
      }
    );
  }

  Widget buildMap (MapState state, Function(LatLng) onSelectPosition) {
    return FlutterMap(
      mapController: mapController,
      options: new MapOptions(
        center: state.currentUserPosition != null ?
          state.currentUserPosition.getLatLng : LatLng(51.8, 71.22),
        zoom: 10,
        interactive: true,
        onTap: (LatLng position) {
          onSelectPosition(position);
        }
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: mapType.url,
          subdomains: ['a', 'b', 'c']
        ),
        new MarkerLayerOptions(
          markers: [
            if (state.currentUserPosition != null)
              this.getCurrentLocationMarker(
                state.currentUserPosition.getLatLng,
                () {
                  onSelectPosition(state.currentUserPosition.getLatLng);
                }
              ),
            if (state.selectedPlace != null) 
              this.selectedPlaceMarker(
                state.selectedPlace.position,
                () {
                  onSelectPosition(state.selectedPlace.position);
                }
              )
          ]
        )
      ],
    );
  }


  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text('Местоположение'),
      actions: [
        searchBar.getSearchAction(context)
      ]
    );
  }


  // MARK: - Methods

  handleStateUpdates (MapState oldState, MapState newState) {
    if (oldState.currentUserPosition != newState.currentUserPosition && newState.currentUserPosition != null) {
      mapController.move(newState.currentUserPosition.getLatLng, mapController.zoom);
    }

    if (oldState.selectedPlace != newState.selectedPlace && newState.selectedPlace != null) {
      mapController.move(newState.selectedPlace.position, mapController.zoom);
    }
  }

  handleNewState (MapState newState) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (newState is MapLoading && newState.isProcessing != null && newState.isProcessing) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: LinearProgressIndicator()
      ));
    } else if (newState is MapError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(newState.errorMessage)
      ));
    }
  }
}

extension PositionExtension on Position {
  LatLng get getLatLng {
    return LatLng(
      this.latitude,
      this.longitude
    );
  }
}