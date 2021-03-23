enum MapTypes { cartoDark, standard, cartoLight, stamen } 

extension MapTypesExtension on MapTypes {
  String get url {
    switch (this) {
      case MapTypes.cartoDark:
        return "https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png";
      case MapTypes.cartoLight: 
        return "https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png";
      case MapTypes.stamen: 
        return "http://c.tile.stamen.com/watercolor/{z}/{x}/{y}.jpg";
      case MapTypes.standard:
        return "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png";
    }
  }

  String get title {
    switch (this) {
      case MapTypes.cartoDark:
        return "Carto Dart";
      case MapTypes.cartoLight: 
        return "Carto Light";
      case MapTypes.stamen: 
        return "Stamen";
      case MapTypes.standard:
        return "Standard";
    }
  }
}