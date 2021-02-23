import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/widgets/independent/pickers/photo_picker.dart';
import 'package:messenger_mobile/modules/edit_profile/presentation/bloc/edit_profile_cubit.dart';
import 'package:messenger_mobile/modules/edit_profile/presentation/bloc/edit_profile_event.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';

class UserPickerView extends StatelessWidget {
  final BuildContext context;
  final User user;
  final File imageFile;

  const UserPickerView({
    @required this.context, 
    @required this.user, 
    @required this.imageFile,
    Key key, 
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PhotoPicker().showImageSourceSelectionDialog(context, (imageSource) {
          BlocProvider.of<EditProfileCubit>(context).pickProfileImage(PickProfileImage(imageSource: imageSource));
        });
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(60.0),
            child: _buildImageView()
          ),
          Positioned(
            bottom: -8,
            right: 0,
            child: Image(
              width: 35,
              height: 35,
              fit: BoxFit.cover,
              image: AssetImage("assets/images/plus_icon.png")
            )
          )
        ],
      ),
    );
  }

  Widget _buildImageView () {
    if (imageFile != null) {
      return _buildImageViewFromUrl(imageFile);
    } else {
      return _buildImageViewFromAssetsOrProfilePicture();
    }
  }

  Widget _buildImageViewFromUrl (File file) {
    return Image.file(file, width: 120, height: 120, fit: BoxFit.cover);
  }

  Widget _buildImageViewFromAssetsOrProfilePicture () {
    return Image(
      width: 120,
      height: 120,
      fit: BoxFit.cover,
      image: user.profileImage != null ? NetworkImage(user.profileImage) : AssetImage("assets/images/default_user.jpg")
    );
  }
}