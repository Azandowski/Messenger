import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileHeader extends StatelessWidget {
  
  final String imageURL;
  final String name;
  final String phoneNumber;
  final String status;
  final Function onPress;
  
  const ProfileHeader({
    Key key, 
    this.imageURL, 
    this.name, 
    this.phoneNumber,
    this.status,
    this.onPress
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 37.5,
            backgroundImage: imageURL == null ? 
              AssetImage('assets/images/default_user.jpg') : NetworkImage(imageURL),
          ),
          SizedBox(width: 10,),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? 'no_name'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5,),
                Text(
                  phoneNumber ?? status ?? '',
                  style: TextStyle(
                    fontSize: 16
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit), 
            onPressed: () {
              if (onPress != null) { onPress(); }  
            }
          )
        ],
      ),
    );
  }
}