import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SwipeLeftText extends StatelessWidget {
  final LayerLink link;
  final Offset offset;

  const SwipeLeftText({Key key, this.link, this.offset}) : super(key: key);

  double lerpOpacity(min, max) {
    var opacity =  lerpDouble(min, max, (offset.dx/100) * (offset.dx/100));
    if(opacity < min){
      return min;
    }else if(opacity > max){
      return max;
    }else{
      return opacity;
    }
  }
  // (((offset.dx/100) * (offset.dx/100)))
  @override
  Widget build(BuildContext context) {
    return CompositedTransformFollower(
      offset: offset,
      link: link,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: lerpOpacity(0.0, 1.0),
        child: MaterialButton(
        child: Text('swipe_left_to_delete'.tr()),
        onPressed: (){

        },
      ),
      )
    );
  }
}