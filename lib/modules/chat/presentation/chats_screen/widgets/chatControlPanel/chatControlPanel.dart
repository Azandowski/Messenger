import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/app/application.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/components/send_message_row.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/components/voiceRecordingRow.dart';
import 'package:messenger_mobile/modules/chat/presentation/time_picker/time_picker_screen.dart';
import 'package:messenger_mobile/core/utils/feedbac_taptic_helper.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chatControlPanel/data/constants.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/components/button_micro/cubit/button_micro_cubit.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/components/swipe_left_text.dart';
import 'package:provider/provider.dart';
import 'package:vibrate/vibrate.dart';

import '../../../../../../app/appTheme.dart';
import '../../../../../../locator.dart';
import '../../bloc/chat_bloc.dart';
import '../components/button_micro/button_micro.dart';
import '../components/pause_button.dart';
import '../components/reply_container.dart';
import 'bloc/voice_record_bloc.dart';
import 'cubit/panel_bloc_cubit.dart';

class ChatControlPanel extends StatefulWidget {
  
  const ChatControlPanel({
    Key key,
    @required this.messageTextController,
    @required this.width,
    @required this.height,gi
  }) : super(key: key);

  final TextEditingController messageTextController;
  final double width;
  final double height;

  @override
  _ChatControlPanelState createState() => _ChatControlPanelState();
}

class _ChatControlPanelState extends State<ChatControlPanel> 
  with TickerProviderStateMixin implements TimePickerDelegate {

  NavigatorState get _navigator => sl<Application>().navKey.currentState;

  AnimationController _microController;

  Animation<Offset> _microAnimation;

  AnimationController _pauseController;

  Animation<Offset> _pauseAnimation;
  
  Animation<Size> _sizeAnimation;
    
  GlobalKey panelKey = GlobalKey();

  GlobalKey recordPanelKey = GlobalKey();

  PanelBlocCubit _panelBloc;
  ChatBloc _chatBloc;
  VoiceRecordBloc _recordBloc;
  ButtonMicroCubit _buttonMicroCubit;

  final LayerLink layerLink = LayerLink();

  final LayerLink recordLink = LayerLink();

  AsyncSnapshot<String> _lastTextStream;

  OverlayEntry pauseButton;
  OverlayEntry swipeLeftText;
  OverlayEntry recordButton;

  Offset recordButtonOffset;
  Offset pauseButtonOffset;
  Offset swipeLeftOffset;

  Size _microButtonSize;


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
      _buttonMicroCubit.holdRecording();
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
      _buttonMicroCubit.makeDecreasingDelete();
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
    _buttonMicroCubit.startMovement();
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
            microSize: _microButtonSize,
            microState: _buttonMicroCubit.state,
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
            microCubit: _buttonMicroCubit,
            onStop: (){
              _recordBloc.add(VoiceStopHolding());
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
    _recordBloc.add(VoiceStartRecording());
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
    if(_buttonMicroCubit.state is ButtonMicroMove){
      _buttonMicroCubit.makeDecreasingSend();
      _recordBloc.add(VoiceStopRecording());
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
    var state = _buttonMicroCubit.state;

    swipeLeftText?.remove();
    swipeLeftOffset = null;

    final RenderBox rb = panelKey.currentContext.findRenderObject();
    var slideHeight = rb.size.height;

    if(_buttonMicroCubit.state is ButtonMicroDecreasing){
      _sizeAnimation = _microController.drive(
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
     _microAnimation =  _microController.drive(
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

    _microController.animateWith(simulation).then((value) {
      if(state is ButtonMicroDecreasing){
        if(state.isDelete){
          _recordBloc.add(VoiceStopRecording());
          print("ON Delete");
        }else{
          _recordBloc.add(VoiceStopRecording());
          //TODO SEND VOICE _recordBloc.add(SendRecord)
          print("ON SEND");
        }
        deleteEveryEntry(isPause: false, isSwipe: false);
       _buttonMicroCubit.resetToStable();
      }else if(state is ButtonMicroHold){
        _recordBloc.add(VoiceHoldRecoriding());
      }
    });
  }

  void _returnPauseButton(Offset pixelsPerSecond, Offset currentOffset, Size size) async {
    var state = _buttonMicroCubit.state;
    if (state is ButtonMicroDecreasing) {

      pauseButton?.remove();
      pauseButton = null;

    } else if(state is ButtonMicroHold) {
      _pauseAnimation =  _pauseController.drive(
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

      _pauseController.animateWith(simulation);
    }
  }
  
  @override
  void initState() {
    super.initState();
    _recordBloc = VoiceRecordBloc();
    _chatBloc = context.read<ChatBloc>();
    _panelBloc = context.read<PanelBlocCubit>();
    _buttonMicroCubit = ButtonMicroCubit();

    _microController = AnimationController(vsync: this, duration: Duration(microseconds: 200));
    _pauseController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _microController.addListener(() {
      setState(() {
        recordButtonOffset = _microAnimation.value;
        if(_buttonMicroCubit.state is ButtonMicroDecreasing){
          _microButtonSize = _sizeAnimation.value;
        }
        recordButton?.markNeedsBuild();
      });
    });

    _pauseController.addListener(() {
      setState(() {
        pauseButtonOffset = _pauseAnimation.value;
        pauseButton?.markNeedsBuild();
      });
    });
  }

  void deleteEveryEntry({bool isPause = true, isSwipe = true}){
    if(recordButton != null){
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

  @override
  void dispose() {
    if(!(_buttonMicroCubit.state is ButtonMicroInitialStable)){
      if(!(_buttonMicroCubit.state is ButtonMicroMove)){
        deleteEveryEntry(isSwipe: false);
      }else{
        deleteEveryEntry();
      }
    }
    _microController.dispose();
    _pauseController.dispose();
    _buttonMicroCubit.close();
    _recordBloc.add(VoiceBlocDispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final panelDecoration = BoxDecoration(
      color: AppColors.pinkBackgroundColor,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 4, blurRadius: 7,
          offset: Offset(0, -4), // changes position of shadow
        ),
      ],
    );
    
    return BlocProvider(
      create: (context) => _recordBloc,
      child: BlocConsumer<VoiceRecordBloc, VoiceRecordState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, voiceState) {
          return CompositedTransformTarget(
              link: layerLink,
              child: Container(
              key: panelKey,
              decoration: panelDecoration,
              child: SafeArea(
                child: BlocBuilder<PanelBlocCubit, PanelBlocState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      state is PanelBlocReplyMessage ?
                        ReplyContainer(
                          cubit: _panelBloc,
                        ) : SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(right: 16, left: 16, bottom: 8),
                        child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                        Expanded(
                          child: CompositedTransformTarget(
                            link: recordLink,
                            child: Container(
                              key: recordPanelKey,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)
                              ),
                              child: voiceState is VoiceRecordEmpty ? 
                                SendMessageRow(widget: widget, panelBloc: _panelBloc) :
                                VoiceRecordingRow(
                                  voiceRecordBloc: _recordBloc,
                                  onCancel: (){
                                    _recordBloc.add(VoiceStopRecording());
                                    _buttonMicroCubit.resetToStable();
                                    deleteEveryEntry(isSwipe: false);
                                  },
                                ),
                            ),
                          )
                      ),
                      SizedBox(width: 5,),
                      StreamBuilder(
                        stream: _panelBloc.textStream,
                        builder: (context, AsyncSnapshot<String> textStream) {
                          var canWrite = !textStream.hasError && widget.messageTextController.text != '' && widget.messageTextController.text != null;
                          return ClipOval(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: AppGradinets.mainButtonGradient,
                              ),
                              child: GestureDetector(
                                onLongPressStart: (details){
                                  if(!canWrite && _buttonMicroCubit.state is ButtonMicroInitialStable){
                                    showIndicator(details);
                                  }
                                },
                                onLongPressMoveUpdate: (details){
                                  if(!canWrite && (_buttonMicroCubit.state is ButtonMicroMove)){
                                    updateIndicator(details);
                                  }
                                },
                                onLongPressEnd: (details) {
                                  if (!canWrite && _buttonMicroCubit.state is ButtonMicroMove){
                                    hideIndicator(details.localPosition);
                                  }
                                },
                                child: (voiceState is VoiceRecordEmpty || voiceState is VoiceRecordingEndWillSend ) ? 
                                  IconButton(
                                    icon: Icon(
                                      !canWrite && !(voiceState is VoiceRecordingEndWillSend) ? Icons.mic : Icons.send,
                                      color: Colors.white
                                    ),
                                    onPressed: () {
                                      if (canWrite) {
                                        if (_chatBloc.state.isSecretModeOn) {
                                          _lastTextStream = textStream;
                                          _navigator.push(TimePickerScreen.route(this));
                                        } else {
                                          _sendMessage(textStream, state);
                                        }
                                      } else {
                                        //TODO MICRO SEND
                                      }
                                    },
                                    splashRadius: 5,
                                    splashColor: Colors.white,
                                  ) : SizedBox(),
                              )
                            ),
                          );
                        }
                      )
                    ],
                    ),
                  ),
                    ],
                  );
                }),
              )
            ),
          );
        },
      ),
    );
  } 


  @override
  void didSelectTimeOption(TimeOptions option) {
    _sendMessage(_lastTextStream, _panelBloc.state, timeDeleted: option.seconds);
  }

  void _sendMessage (
    AsyncSnapshot<String> textStream, 
    PanelBlocState state,
    {int timeDeleted}
  ) {
    _panelBloc.clear();
    _panelBloc.detachMessage();
    widget.messageTextController.clear();
    Message forwardMessage;
    
    if (state is PanelBlocReplyMessage) {
      forwardMessage = state.messageViewModel.message;
    }

    _chatBloc.add(
      MessageSend(
        message: textStream.data,
        forwardMessage: forwardMessage,
        timeDeleted: timeDeleted
      )
    );
  } 
}

