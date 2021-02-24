import 'package:flutter/material.dart';

class PhotoPickerView extends StatelessWidget {
  final Function onSelectPhoto;
  final ImageProvider defaultPhotoProvider;

  const PhotoPickerView({
    @required this.onSelectPhoto, 
    @required this.defaultPhotoProvider,
    Key key
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onSelectPhoto,
      child: Stack(
        children: [
          ClipOval(child: _buildImageView(w / 3)),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image(
              width: 45,
              height: 45,
              fit: BoxFit.cover,
              image: AssetImage(
                defaultPhotoProvider != null ? 'assets/images/camera_icon.png' : 
                  "assets/images/plus_icon.png"
              ))
            )
        ],
      ),
    );
  }

  Widget _buildImageView(double width) {
    if (defaultPhotoProvider != null) {
      return Image(
        image: defaultPhotoProvider,
        width: width,
        height: width,
        fit: BoxFit.cover,
      );
    } else {
      return Image(
        width: width,
        height: width,
        fit: BoxFit.cover,
        image: AssetImage("assets/images/default_user.jpg")
      );
    }
  }
}