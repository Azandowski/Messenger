import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileHeader extends StatelessWidget {
  
  final String imageURL;
  final String name;
  final String phoneNumber;

  const ProfileHeader({
    Key key, 
    this.imageURL, 
    this.name, 
    this.phoneNumber
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 75,
            backgroundImage: imageURL == null ? 
              AssetImage('default_user.jpg') : NetworkImage(imageURL),
          ),
          SizedBox(width: 10,),
          Column(
            children: [
              Text(
                name ?? 'no_name',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5,),
              Text(
                phoneNumber,
                style: TextStyle(
                  fontSize: 16
                )
              )
            ],
          )
        ],
      ),
    );
  }
}