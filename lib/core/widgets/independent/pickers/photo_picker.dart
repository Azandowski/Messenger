import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/appTheme.dart';

class PhotoPicker {
  static final PhotoPicker _shared = PhotoPicker._internal();

  factory PhotoPicker() {
    return _shared;
  }

  PhotoPicker._internal();

  Future<void> showImageSourceSelectionDialog(
      BuildContext context, Function(ImageSource) callback) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Theme.of(context).backgroundColor,
              title: Text(
                "select_one_option",
                style: AppFontStyles.mainStyle,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          "gallery",
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                      onTap: () {
                        callback(ImageSource.gallery);
                        Navigator.pop(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text("camera",
                            style: TextStyle(
                                color: Theme.of(context).accentColor)),
                      ),
                      onTap: () {
                        callback(ImageSource.camera);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }
}
