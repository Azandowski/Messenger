import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong/latlong.dart';

enum LocationFailure { 
  permissionDenied, locationDisabled
}

extension LocationFailureExtension on LocationFailure {
  String get message {
    switch (this) {
      case LocationFailure.permissionDenied:
        return 'permissionDenied';
      case LocationFailure.locationDisabled:
        return "locationDisabled";
    }
  }
}

abstract class LocalMapDatasource {
  Future<Position> getCurrentPosition ();
  Future<bool> isLocationEnabled ();
  Future<PermissionStatus> checkPermission();
  Future<PermissionStatus> requestPermission();
  Future<List<Placemark>> geocodeCoordinate(LatLng position);
}


class LocalMapDatasourceImpl extends LocalMapDatasource {
  
  @override
  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best
    );
  }

  @override
  Future<PermissionStatus> checkPermission() async {
    LocationPermission status = await Geolocator.checkPermission();
    return status.permissionStatus;
  }

  @override
  Future<bool> isLocationEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<PermissionStatus> requestPermission() async {
    LocationPermission status = await Geolocator.requestPermission();
    return status.permissionStatus;
  }

  @override
  Future<List<Placemark>> geocodeCoordinate(LatLng position) {
    return placemarkFromCoordinates(position.latitude, position.longitude);
  }
}

extension LocationPermissionExtension on LocationPermission {
  PermissionStatus get permissionStatus {
    switch (this) {
      case LocationPermission.always: case LocationPermission.whileInUse:
        return PermissionStatus.granted;
      case LocationPermission.deniedForever:
        return PermissionStatus.permanentlyDenied;
      default: 
        return PermissionStatus.denied;
    }
  }
}

//5uRVxLPpLqDNX9xcLXjA
//f9SDwZiglj1cWsUZT2_ufw
//8vwqlMtTR-6Bl-sUWrpcca8sJ-D6ir5NWBYmVpTiohp_QkJV0PibR2DSVdftG1mRVICmgBB9YVtc0QW1aq0wkg

//5PWyNk5E1IzV5MjrV_JbhA
//IiCFnPlFv3zxwU-2VSHEuNkR_DbqHGZFZamJ8mGsVCR1hGLr6G_D6JtOLDDC4beNaTCXiSwUpT_dc3kmAIqfKQ