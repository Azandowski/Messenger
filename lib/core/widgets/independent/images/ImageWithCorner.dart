import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  final bool isFromAsset;
  final String path;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  AvatarImage({
    this.isFromAsset, 
    this.path, 
    this.width = 75, 
    this.height = 75,
    this.borderRadius
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(10.0),
      child: !isFromAsset && path != null ? FadeInImage(
        placeholder: AssetImage("assets/images/logo.png"), 
        image: NetworkImage(path),
        width: width,
        height: height,
        fit: BoxFit.cover
      ) : Image.asset(
          path == null || path == '' ? "assets/images/logo.png" : path, 
          width: width,
          height: height,
          fit: BoxFit.cover
        )
    );
  } 
}