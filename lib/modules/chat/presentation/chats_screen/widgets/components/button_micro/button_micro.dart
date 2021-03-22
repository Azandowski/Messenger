import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chatControlPanel/data/constants.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/components/button_micro/cubit/button_micro_cubit.dart';
import '../../../../../../../app/appTheme.dart';

class ButtonMicro extends StatelessWidget {
  final LayerLink link;
  final Offset offset;
  final Size microSize;
  final ButtonMicroState microState;
  const ButtonMicro({Key key, this.link, this.offset, this.microSize, @required this.microState}) : super(key: key);

  double lerp(double min, double max, double width) {
    return lerpDouble(min, max, ((offset.dx/2)/width));
  }

  double lerpIcon(double a, b, double t){
    var val =  -(-(t*t) - b/2)/10;
    if(val < a){
      return a;
    }else{
      return val;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return CompositedTransformFollower(
      offset: offset,
      link: link,
      child: ClipOval(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: microState is ButtonMicroDecreasing ? microSize.width :  lerpIcon(minMicroButtonSize.width, maxMicroButtonSize.width,((offset.dx)/10)),
        height: microState is ButtonMicroDecreasing ? microSize.height : lerpIcon(minMicroButtonSize.height, maxMicroButtonSize.height,((offset.dx/10))),
        decoration: BoxDecoration(
          gradient: AppGradinets.mainButtonGradient,
        ),
          child: GestureDetector(
            onTap: (){
              print('you may sleep');
            },
            child: Icon(
              microState is ButtonMicroHold ? Icons.send : Icons.mic,
              color: Colors.white,
              size: lerp(12,32, w/2),
            ),
          )
        ),
      ),
    );
  }
}
