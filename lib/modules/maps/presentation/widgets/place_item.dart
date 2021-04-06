
import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/maps/domain/entities/place.dart';

class PlaceItem extends StatelessWidget {
  final Place place;

  PlaceItem({
    @required this.place
  });

  @override
  Widget build(BuildContext context) {  
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Image(
            image: AssetImage('assets/images/place_icon.png'),
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
                  place.title,
                  style: AppFontStyles.black14w400,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4,),
                Text(
                  place.street ?? '',
                  style: AppFontStyles.grey12w400,
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