import 'package:equatable/equatable.dart';
import 'package:latlong/latlong.dart';

class Place extends Equatable {
  final LatLng position;
  final String title;
  final num distance;
  final String street;

  Place({this.position, this.title, this.distance, this.street});

  @override
  List<Object> get props => [position, title, distance, street];

  @override
  String toString() {
    return "position = $position   title = $title   distance = $distance   street = $street";
  }
}
