enum HereEndpoints {
  getNearbyPlaces,
  searchPlaces
}

extension HereEnpointsExtension on HereEndpoints {
  
  String get host {
    return 'places.ls.hereapi.com';
  }

  String get path {
    switch (this) {
      case HereEndpoints.getNearbyPlaces:
        return 'places/v1/discover/around';
      case HereEndpoints.searchPlaces:
        return 'places/v1/discover/search';
    }
  }


  Map get headers => {
    'Accept-Language': 'ru-RU'
  };

  Uri buildURL({
    Map<String, dynamic> queryParameters, 
  }) {
    return Uri(
      scheme: 'https',
      host: this.host,
      path: this.path,
      queryParameters: queryParameters ?? {}
    );
  }
}