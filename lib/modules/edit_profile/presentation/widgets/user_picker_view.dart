import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../profile/domain/entities/user.dart';

class UserPickerView extends StatelessWidget {
  final BuildContext context;
  final User user;
  final File imageFile;
  final Function onSelectPhoto;

  const UserPickerView({
    @required this.context,
    @required this.user,
    @required this.imageFile,
    @required this.onSelectPhoto,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelectPhoto();
      },
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(60.0),
              child: _buildImageView()),
          Positioned(
              bottom: -8,
              right: 0,
              child: Image(
                  width: 35,
                  height: 35,
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/plus_icon.png")))
        ],
      ),
    );
  }

  Widget _buildImageView() {
    if (imageFile != null) {
      return _buildImageViewFromUrl(imageFile);
    } else {
      return _buildImageViewFromAssetsOrProfilePicture();
    }
  }

  Widget _buildImageViewFromUrl(File file) {
    return Image.file(file, width: 120, height: 120, fit: BoxFit.cover);
  }

  Widget _buildImageViewFromAssetsOrProfilePicture() {
    return Image(
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        image: user.profileImage != null
            ? NetworkImage(user.profileImage)
            : AssetImage("assets/images/default_user.jpg"));
  }
}
