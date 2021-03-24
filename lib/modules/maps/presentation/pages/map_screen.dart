import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:messenger_mobile/core/utils/search_engine.dart';
import 'package:messenger_mobile/modules/maps/domain/entities/place.dart';
import 'package:messenger_mobile/modules/maps/presentation/widgets/map_bottom_sheet.dart';
import 'map_screen_helper.dart';
import 'package:messenger_mobile/modules/maps/domain/entities/map_type.dart';
import 'package:messenger_mobile/modules/maps/presentation/cubit/map_cubit.dart';
import 'package:latlong/latlong.dart';

abstract class MapScreenDelegate {
  void didSelectCoordinates (LatLng position);
}

class MapScreen extends StatefulWidget {
  
  static Route route({
    MapScreenDelegate delegate
  }) {
    return MaterialPageRoute<void>(builder: (_) => MapScreen(
      delegate: delegate,
    ));
  }

  final MapScreenDelegate delegate;
  final LatLng defaultPosition;
  
  MapScreen({
    this.delegate,
    this.defaultPosition
  });

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> implements SearchEngingeDelegate {
  
  // MARK: - Props

  final MapController mapController = MapController();  
  MapCubit mapCubit;
  MapTypes mapType = MapTypes.cartoLight;
  SearchBar searchBar;
  SearchEngine searchEngine;

  // MARK: - Life-Cycle

  @override
  void initState() {
    this.initScreen();
    searchBar = new SearchBar(
      inBar: false,
      closeOnSubmit: false,
      clearOnSubmit: false,
      setState: setState,
      onSubmitted: (String text) {
        mapCubit.showLoading();
        searchEngine.onTextChanged(text);
      },
      buildDefaultAppBar: buildAppBar,
      hintText: 'Поиск'
    );

    searchEngine = SearchEngine(delegate: this);

    if (widget.defaultPosition != null) {
      mapCubit.didSelectPosition(widget.defaultPosition);
    }

    super.initState();
  }

  @override
  void dispose() {
    mapCubit.close();
    super.dispose();
  }

  // MARK: - UI

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MapCubit>(
      create: (context) => mapCubit,
      child: BlocConsumer<MapCubit, MapState>(
        listenWhen: (MapState oldState, MapState newState) {
          this.handleStateUpdates(oldState, newState);
          return true;
        },
        listener: (context, state) {
          handleNewState(state);
        },
        builder: (context, state) {
          return Scaffold(
            appBar: searchBar.build(context),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  buildMap(state, (position) {
                    mapCubit.didSelectPosition(position);
                  }),
                  MapBottomSheet(
                    currentUserLocation: state.currentUserPosition,
                    places: state.places ?? [],
                    isLoading: state is MapLoading && state.isPlacesLoading,
                    selectedPlace: state.selectedPlace,
                    hasDelegate: widget.delegate != null,
                    didSelectPlace: (Place newSelectedPlace) {
                      mapCubit.didSelectPlace(newSelectedPlace);
                    },
                    didComplete: () {
                      if (widget.delegate != null) {
                        if (state.selectedPlace != null) {
                          widget.delegate.didSelectCoordinates(state.selectedPlace.position);
                        } else {
                          widget.delegate.didSelectCoordinates(state.currentUserPosition.getLatLng);
                        }
                      }

                      Navigator.of(context).pop();
                    },
                  )
                ],
              )
            ),
          );
        },
      ),
    );
  }

  @override
  void startSearching({
    String text
  }) {
    mapCubit.findPlaces(text);
  }
}
