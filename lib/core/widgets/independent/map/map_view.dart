import 'package:flutter_map/flutter_map.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:latlong/latlong.dart';
import 'package:messenger_mobile/modules/maps/domain/entities/map_type.dart';

class MapView extends StatelessWidget {
  final LatLng position;
  final num width;
  final num heigth;

  MapView({
    @required this.position,
    @required this.width,
    @required this.heigth
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: heigth,
      child: FlutterMap(
        options: new MapOptions(
          center: position,
          zoom: 10,
          interactive: false,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: MapTypes.cartoLight.url,
            subdomains: ['a', 'b', 'c']
          ),
          new MarkerLayerOptions(
            markers: [
              Marker (
                width: 40,
                height: 40,
                point: position,
                builder: (ctx) => 
                  Image.asset("assets/icons/pin.png",)
              )
            ]
          )
        ],
      ),
    );
  }
}