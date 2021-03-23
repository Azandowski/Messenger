import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../../../../app/appTheme.dart';
import '../../../../../../../app/application.dart';
import '../../../../../../../locator.dart';
import '../../../../../domain/entities/message.dart';
import '../../../../time_picker/time_picker_screen.dart';
import '../../../bloc/chat_bloc.dart';
import '../../components/button_micro/cubit/button_micro_cubit.dart';
import '../../components/reply_container.dart';
import '../../components/send_message_row.dart';
import '../../components/voiceRecordingRow.dart';
import '../bloc/voice_record_bloc.dart';
import '../cubit/panel_bloc_cubit.dart';
import 'chatControlPanelHelper.dart';

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
  ChatControlPanelState createState() => ChatControlPanelState();
}

class ChatControlPanelState extends State<ChatControlPanel> 
  with TickerProviderStateMixin implements TimePickerDelegate {

  NavigatorState get _navigator => sl<Application>().navKey.currentState;

  AnimationController microController;

  Animation<Offset> microAnimation;

  AnimationController pauseController;

  Animation<Offset> pauseAnimation;
  
  Animation<Size> sizeAnimation;
    
  GlobalKey panelKey = GlobalKey();

  GlobalKey recordPanelKey = GlobalKey();

  PanelBlocCubit _panelBloc;
  ChatBloc chatBloc;
  VoiceRecordBloc recordBloc;
  ButtonMicroCubit buttonMicroCubit;

  final LayerLink layerLink = LayerLink();

  final LayerLink recordLink = LayerLink();

  AsyncSnapshot<String> _lastTextStream;

  OverlayEntry pauseButton;
  OverlayEntry swipeLeftText;
  OverlayEntry recordButton;

  Offset recordButtonOffset;
  Offset pauseButtonOffset;
  Offset swipeLeftOffset;

  Size microButtonSize;
  
  @override
  void initState() {
    super.initState();
    chatBloc = context.read<ChatBloc>();
    _panelBloc = context.read<PanelBlocCubit>();
    buttonMicroCubit = ButtonMicroCubit();
    recordBloc = VoiceRecordBloc(chatBloc: chatBloc);

    microController = AnimationController(vsync: this, duration: Duration(microseconds: 200));
    pauseController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    microController.addListener(() {
      setState(() {
        recordButtonOffset = microAnimation.value;
        if(buttonMicroCubit.state is ButtonMicroDecreasing){
          microButtonSize = sizeAnimation.value;
        }
        recordButton?.markNeedsBuild();
      });
    });

    pauseController.addListener(() {
      setState(() {
        pauseButtonOffset = pauseAnimation.value;
        pauseButton?.markNeedsBuild();
      });
    });
  }

  @override
  void dispose() {
    if(!(buttonMicroCubit.state is ButtonMicroInitialStable)){
      if(!(buttonMicroCubit.state is ButtonMicroMove)){
        deleteEveryEntry(isSwipe: false);
      }else{
        deleteEveryEntry();
      }
    }
    microController.dispose();
    pauseController.dispose();
    buttonMicroCubit.close();
    recordBloc.add(VoiceBlocDispose());
    super.dispose();
  }
  
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => recordBloc,
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
                                voiceRecordBloc: recordBloc,
                                onCancel: (){
                                  recordBloc.add(VoiceStopRecording());
                                  buttonMicroCubit.resetToStable();
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
                                    if(!canWrite && buttonMicroCubit.state is ButtonMicroInitialStable){
                                      showIndicator(details);
                                    }
                                  },
                                  onLongPressMoveUpdate: (details){
                                    if(!canWrite && (buttonMicroCubit.state is ButtonMicroMove)){
                                      updateIndicator(details);
                                    }
                                  },
                                  onLongPressEnd: (details) {
                                    if (!canWrite && buttonMicroCubit.state is ButtonMicroMove){
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
                                          if (chatBloc.state.isSecretModeOn) {
                                            _lastTextStream = textStream;
                                            _navigator.push(TimePickerScreen.route(this));
                                          } else {
                                            _sendMessage(textStream, state);
                                          }
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
                ],);
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

    chatBloc.add(
      MessageSend(
        message: textStream.data,
        forwardMessage: forwardMessage,
        timeDeleted: timeDeleted
      )
    );
  } 
}

