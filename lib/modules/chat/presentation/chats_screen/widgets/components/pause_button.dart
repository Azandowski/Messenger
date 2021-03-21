import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/components/button_micro/cubit/button_micro_cubit.dart';

import '../../../../../../app/appTheme.dart';

class PauseButton extends StatelessWidget {
  final LayerLink link;
  final Offset offset;
  final ButtonMicroCubit microCubit;
  final Function onStop;
  const PauseButton({Key key, this.link, this.offset, @required this.microCubit, @required this.onStop}) : super(key: key);

  double lerp(double min, double max, double width) => -lerpDouble(min, max, ((offset.dy/2)/width));
  
  double lerpIcon(a, b, double t){
    var val =  -(-(t*t) - b/2)/10;
    if(val < a){
      return a;
    }else{
      return val;
    }
  }

  double lerpRadius(min, max, height){
    var radius = -(offset.dy * offset.dy)/400 + 60;
    if(radius < 3){
      return 3;
    }else{
      return radius; 
    }
  }

  // int lerpColor(min, max) => (((offset.dy + 100) * (offset.dy+ 100))/39.2156862745).round();
  
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    // var colorVal = 255 - lerpColor(0, 255);
    var state = microCubit.state;
    return CompositedTransformFollower(
      offset: offset,
      link: link,
      child: GestureDetector(
        onTap: onStop,
        child: ClipOval(
        child: Container(
        color: AppColors.indicatorColor,
        padding: EdgeInsets.all(8),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: state is ButtonMicroHold ? BorderRadius.circular(3) : BorderRadius.circular(lerpRadius(0, 100, h)),
              color: Colors.white,
            ),
            ),
          ),
        ),
      ),
    );
  }
}