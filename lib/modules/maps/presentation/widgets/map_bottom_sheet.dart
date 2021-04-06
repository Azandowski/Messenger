import 'package:geolocator/geolocator.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/image_text_view.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/divider_wrapper.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/maps/domain/entities/place.dart';
import 'package:messenger_mobile/modules/maps/presentation/widgets/map_selected_place.dart';
import 'package:messenger_mobile/modules/maps/presentation/widgets/place_item.dart';
import 'package:easy_localization/easy_localization.dart';

class MapBottomSheet extends StatefulWidget {
  
  final Position currentUserLocation;
  final Place selectedPlace;
  final List<Place> places;
  final bool isLoading;
  final Function(Place) didSelectPlace;
  final Function didComplete;
  final bool hasDelegate;

  MapBottomSheet({
    @required this.currentUserLocation,
    @required this.places,
    @required this.selectedPlace,
    @required this.didSelectPlace,
    @required this.didComplete,
    @required this.hasDelegate,
    this.isLoading = false,
  });

  @override
  _MapBottomSheetState createState() => _MapBottomSheetState();
}

class _MapBottomSheetState extends State<MapBottomSheet> {
  
  String _draggableScrollableSheetKey = DateTime.now().toString();
  num _initialExtent = 0.4;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      key: Key(_draggableScrollableSheetKey),
      initialChildSize: _initialExtent,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (sheetContext, scrollController) { 
        return Container(
          decoration: _getBannerDecoration(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: buildHorizontalPin(),
                  ),
                  if (widget.hasDelegate)
                    ...[
                      GestureDetector(
                        onTap: () {
                          widget.didComplete();
                        },
                        child: MapSelectedPlace(
                          selectedPlace: widget.selectedPlace,
                          userLocation: widget.currentUserLocation,
                        ),
                      ),
                      buildSelectPlaceBanner(),
                    ],
                  if (widget.places.length > 0 || widget.isLoading)
                    DividerWrapper(
                      children: widget.isLoading ? getLoadingSpinners() : 
                        widget.places.map((e) => GestureDetector(
                          child: PlaceItem(place: e),
                          onTap: () {
                            setState(() {
                              _initialExtent = 0.35;
                              _draggableScrollableSheetKey = DateTime.now().toString();
                            });
                            
                            widget.didSelectPlace(e);
                          },
                        )).toList()
                    )
                  else
                    Center(
                      child: EmptyView(
                        text: 'nothing_found'.tr(),
                      )
                    )
                ],
              )
            ),
          )
        );
      }
    );
  }

  Widget buildHorizontalPin () {
    return Container(
      width: 35,
      height: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.grey[400]
      ),
    );
  }

  Widget buildSelectPlaceBanner () {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 20),
      child: Center(
        child: Text(
          'or_select_place'.tr(),
          style: AppFontStyles.mediumStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  BoxDecoration _getBannerDecoration () {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15), topRight: Radius.circular(15)
      ),
      boxShadow: [
        BoxShadow(
          blurRadius: 20,
          spreadRadius: 10,
          color: Color.fromARGB(90, 0, 0, 0)
        )
      ]
    );
  }

  List<Widget> getLoadingSpinners () {
    return [1, 2, 3, 4, 5, 6, 7, 8].map((e) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: CellShimmerItem(
        circleSize: 35,
        hasPadding: false,
      ),
    )).toList();
  }
}
