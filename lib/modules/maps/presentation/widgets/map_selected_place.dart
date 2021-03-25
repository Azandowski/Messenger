import 'package:geolocator/geolocator.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/maps/domain/entities/place.dart';
import 'package:latlong/latlong.dart';

class MapSelectedPlace extends StatelessWidget {
  
  final Position userLocation;
  final Place selectedPlace;
  
  MapSelectedPlace({
    @required this.userLocation,
    @required this.selectedPlace
  });

  bool get isSelectedLocation {
    return selectedPlace != null 
       && (userLocation == null || selectedPlace.position != LatLng(userLocation?.latitude, userLocation?.longitude));
  }

  @override
  Widget build(BuildContext context) {
    return userLocation == null && selectedPlace == null ? Container() : 
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: AppGradinets.mainButtonGradient,
        ),
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
        child: Row(
          children: [
            Image(
              image: AssetImage('assets/images/gradient_pin.png'),
              width: 35,
              height: 35,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSelectedLocation ? 'Отправить выбранные геоданные' : 
                      'Отправить мои геоданные',
                    style: AppFontStyles.white14w400.copyWith(
                      fontWeight: FontWeight.bold
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4,),
                  Text(
                    isSelectedLocation ? selectedPlace.street : 
                      'С точностью до 12 метров',
                    style: AppFontStyles.white12w400,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      );
  }
}