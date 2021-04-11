import 'package:flutter/physics.dart';
import 'package:vibrate/vibrate.dart';

import '../../../../../../../core/utils/feedbac_taptic_helper.dart';
import '../../../pages/chat_screen_import.dart';
import '../../components/button_micro/button_micro.dart';
import '../../components/button_micro/cubit/button_micro_cubit.dart';
import '../../components/pause_button.dart';
import '../../components/swipe_left_text.dart';
import '../bloc/voice_record_bloc.dart';
import '../data/constants.dart';
import 'chatControlPanel.dart';

extension ChatControlPanelStateHelper on ChatControlPanelState {

  Offset getPanelOffset(Offset dragOffset) {
    final RenderBox rb = panelKey.currentContext.findRenderObject();
    var slideWidth = rb.size.width;
    var slideHeight = rb.size.height;
    var heightScreen = MediaQuery.of(context).size.height;

    final double x = getX((slideWidth + (dragOffset.dx - (maxMicroButtonSize.width/1.5))),slideWidth/1.75, details: dragOffset);
    final double y = getYPanel(dragOffset.dy - (slideHeight - maxMicroButtonSize.height/2),-heightScreen*0.125);
    return Offset(x, y);
  }

  getYPanel(position,maxY){
    if(maxY > position){
      return maxY;
    }else{
      return position;
    }
  }

  Offset getPauseOffset(Offset dragOffset) {
    final RenderBox rb = panelKey.currentContext.findRenderObject();
    var slideWidth = rb.size.width;
    final double x = slideWidth*0.9 - 8;
    var heightScreen = MediaQuery.of(context).size.height;
    var yVar = dragOffset.dy + -heightScreen*0.130;
    final double y = getY(yVar, -heightScreen*0.130, -heightScreen*0.25,details: dragOffset);
    return Offset(x, y);
  }

  Offset getSwipeOffset(Offset dragOffset) {
    final RenderBox rb = recordPanelKey.currentContext.findRenderObject();
    var slideWidth = rb.size.width;
    final double x = getXSwipe((slideWidth + dragOffset.dx-slideWidth*0.7),slideWidth*0.2,slideWidth*0.3);
    final double y = 0;
    return Offset(x, y);
  }

  double getY(position, minY, maxY,{details}){
    if(maxY > position){
      buttonMicroCubit.holdRecording();
      hideIndicator(details);
      FeedbackEngine.showFeedback(FeedbackType.selection);
      return maxY;
    }else if (minY < position){
      return minY;
    }else{
      return position;
    }
  }

  double getX(position, maxX,{details}){
    if(maxX > position){
      buttonMicroCubit.makeDecreasingDelete();
      hideIndicator(details);
      return maxX;
    }else{
      return position;
    }
  }

  double getXSwipe(position, max, min){
    if(max > position){
      return max;
    }else if(min < position){
      return min;
    }else{
      return position;
    }
  }

  void showIndicator(LongPressStartDetails details) {
    buttonMicroCubit.startMovement();
    FeedbackEngine.showFeedback(FeedbackType.heavy);
    recordButtonOffset = getPanelOffset(details.localPosition);
    pauseButtonOffset = getPauseOffset(details.localPosition);
    swipeLeftOffset = getSwipeOffset(details.localPosition);

    recordButton = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: 0,
          right: 0,
          child: ButtonMicro(
            link: layerLink,
            offset: recordButtonOffset,
            microSize: microButtonSize,
            microState: buttonMicroCubit.state,
            onSendAudio: (){
              if(recordBloc.state is VoiceRecording){
                recordBloc.add(VoiceStopRecording());
                recordBloc.add(VoiceSendAudio());     
                buttonMicroCubit.resetToStable();
                deleteEveryEntry(isSwipe: false);         
              }
            },
          ),
        );
      },
    );
    pauseButton = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: 0,
          right: 0,
          child: PauseButton(
            link: layerLink,
            offset: pauseButtonOffset,
            microCubit: buttonMicroCubit,
            onStop: (){
              recordBloc.add(VoiceStopHolding());
              deleteEveryEntry(isSwipe: false);
            }
          ),
        );
      },
    );

    swipeLeftText = OverlayEntry(
        builder: (BuildContext context) {
          return Positioned(
            top: 0,
            right: 0,
            child: SwipeLeftText(
              link: recordLink,
              offset: swipeLeftOffset,
            ),
          );
      },
    );

  Overlay.of(context).insertAll([pauseButton, swipeLeftText, recordButton]);
    recordBloc.add(VoiceStartRecording());
  }

  void updateIndicator(LongPressMoveUpdateDetails details) {
    recordButtonOffset = getPanelOffset(details.localPosition);
    pauseButtonOffset = getPauseOffset(details.localPosition);
    swipeLeftOffset = getSwipeOffset(details.localPosition);

    swipeLeftText?.markNeedsBuild();
    pauseButton?.markNeedsBuild();
    recordButton?.markNeedsBuild();
  }

  void hideIndicator(Offset offset) {
    if(buttonMicroCubit.state is ButtonMicroMove){
      buttonMicroCubit.makeDecreasingSend();
      recordBloc.add(VoiceStopRecording());
    }
    var size = MediaQuery.of(context).size;

    var t = recordButtonOffset.dx/10;
    var b = maxMicroButtonSize.width;
    double heightAndWidth =  -(-(t*t) - b/2)/10;

    _returnRecordButton(
      pixelsPerSecond: offset,
      currentOffset: recordButtonOffset,
      size: size,
      microSize: Size(heightAndWidth, heightAndWidth));
    _returnPauseButton(offset, pauseButtonOffset, size);

  }

   void _returnRecordButton({
    Offset pixelsPerSecond, Offset currentOffset, Size size,
    Size microSize
  }) async {
    var state = buttonMicroCubit.state;

    swipeLeftText?.remove();
    swipeLeftOffset = null;

    final RenderBox rb = panelKey.currentContext.findRenderObject();
    var slideHeight = rb.size.height;

    if(buttonMicroCubit.state is ButtonMicroDecreasing){
      sizeAnimation = microController.drive(
        Tween<Size>(
          begin: microSize,
          end: Size(0,0),
        )
      );
    }
    var yCoordinate;
    var xCoordinate;
    if(state is ButtonMicroDecreasing){
      yCoordinate = -slideHeight + (maxMicroButtonSize.height/1.3);
      xCoordinate = size.width*0.9;
    }else{
      yCoordinate = -slideHeight + (maxMicroButtonSize.height/2);
      xCoordinate = size.width*0.8;
    }
     microAnimation = microController.drive(
      Tween<Offset>(
        begin: currentOffset,
        end: Offset(xCoordinate, yCoordinate)
      ),
    );

    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 70,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    microController.animateWith(simulation).then((value) {
      if(state is ButtonMicroDecreasing){
        if(state.isDelete){
          recordBloc.add(VoiceStopRecording());
          print("ON Delete");
        }else{
          recordBloc.add(VoiceStopRecording());
          recordBloc.add(VoiceSendAudio());
          buttonMicroCubit.resetToStable();
        }
        deleteEveryEntry(isPause: false, isSwipe: false);
        buttonMicroCubit.resetToStable();
      }else if(state is ButtonMicroHold){
        recordBloc.add(VoiceHoldRecoriding());
      }
    });
  }

  void _returnPauseButton(Offset pixelsPerSecond, Offset currentOffset, Size size) async {
    var state = buttonMicroCubit.state;
    if (state is ButtonMicroDecreasing) {

      pauseButton?.remove();
      pauseButton = null;

    } else if(state is ButtonMicroHold) {
      pauseAnimation =  pauseController.drive(
        Tween<Offset>(
          begin: currentOffset,
          end: Offset(size.width*0.9 - 8, -size.height*0.1),
        ),
      );

      final unitsPerSecondX = pixelsPerSecond.dx / size.width;
      final unitsPerSecondY = pixelsPerSecond.dy / size.height;
      final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
      final unitVelocity = unitsPerSecond.distance;

      const spring = SpringDescription(
        mass: 30,
        stiffness: 1,
        damping: 1,
      );

      final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

      pauseController.animateWith(simulation);
    }
  }

   void deleteEveryEntry({bool isPause = true, isSwipe = true}) {
    if (recordButton != null){
      recordButton?.remove();
      recordButton = null;
    }
    if(pauseButton != null && isPause){
      pauseButton?.remove();
      pauseButton = null;
    }
    if(swipeLeftText != null  && isSwipe){
      swipeLeftText?.remove();
      swipeLeftText = null;
    }
  }
  
  void handleKeyboard ({
    @required bool isShow
  }) {
    isShow ? messageFieldNode.requestFocus() : messageFieldNode.unfocus();
  }
}
