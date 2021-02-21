import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  
  final ProfileItemData profileItemData;
  final Function onTap;

  const ProfileItem({
    @required this.profileItemData,
    this.onTap,
    Key key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) { onTap(); }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.white,
        child: ListTile(
          leading: Icon(
            profileItemData.icon,
            color: profileItemData.isRed ? Colors.red : Colors.grey
          ),
          title: Text(
            profileItemData.title,
            style: TextStyle(
              color: profileItemData.isRed ? Colors.red : Colors.black
            )
          ),
        ),
      ),
    );
  }
}

class ProfileItemData {
  final IconData icon;
  final String title;
  final bool isRed;

  ProfileItemData({
    @required this.icon, 
    @required this.title, 
    @required this.isRed
  });
}