import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/utils/list_helper.dart';
import 'package:messenger_mobile/core/blocs/audioplayer/bloc/audio_player_bloc.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chatControlPanel/data/chat_bottom_panel_types.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';
import 'package:messenger_mobile/modules/groupChat/presentation/choose_contacts/choose_contacts_page.dart';
import 'package:messenger_mobile/modules/groupChat/presentation/choose_contacts/choose_contacts_screen.dart';
import 'package:messenger_mobile/modules/maps/presentation/pages/map_screen.dart';
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
import '../chat_bottom_panel.dart';
import '../cubit/panel_bloc_cubit.dart';
import 'chatControlPanelHelper.dart';

class ChatControlPanel extends StatefulWidget {
  
  const ChatControlPanel({
    Key key,
    @required this.messageTextController,
    @required this.width,
    @required this.height,
    @required this.canSendMedia
  }) : super(key: key);

  final TextEditingController messageTextController;
  final double width;
  final double height;
  final bool canSendMedia;

  @override
  ChatControlPanelState createState() => ChatControlPanelState();
}

class ChatControlPanelState extends State<ChatControlPanel> 
  with TickerProviderStateMixin 
    implements TimePickerDelegate, MapScreenDelegate, ContactChooseDelegate {

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
  AudioPlayerBloc _audioPlayerBloc;

  final LayerLink layerLink = LayerLink();

  final LayerLink recordLink = LayerLink();

  MessageSend _messageNeededToBeSent;

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
    _audioPlayerBloc = BlocProvider.of<AudioPlayerBloc>(context);
    recordBloc = VoiceRecordBloc(
      chatBloc: chatBloc,
      audioPlayerBloc: _audioPlayerBloc,
    );

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
        listener: (context, state) {},
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
                          ReplyContainer(cubit: _panelBloc) : SizedBox(height: 4),
                        
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
                                      SendMessageRow(widget: widget, panelBloc: _panelBloc) 
                                        : VoiceRecordingRow(
                                          voiceRecordBloc: recordBloc,
                                          audioPlayerBloc: _audioPlayerBloc,
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
                                  var canWrite = !textStream.hasError && 
                                    widget.messageTextController.text != '' && widget.messageTextController.text != null;
                                  
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
                                              if (canWrite && !(voiceState is VoiceRecordingEndWillSend)) {
                                                _messageNeededToBeSent = MessageSend(
                                                  message: textStream.data
                                                );

                                                if (chatBloc.state.isSecretModeOn) {
                                                  _navigator.push(TimePickerScreen.route(this));
                                                } else {
                                                  _sendMessage(state);
                                                }
                                              } else if(!canWrite && (voiceState is VoiceRecordingEndWillSend)) {
                                                recordBloc.add(VoiceStopRecording());
                                                recordBloc.add(VoiceSendAudio());
                                                buttonMicroCubit.resetToStable();
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
                        if (state.showBottomPanel)
                          ChatBottomPanel(
                            didPressOnItem: _didSelectMediaOption,
                            canSendMedia: widget.canSendMedia
                          )
                      ]
                    );
                  }
                ),
              ) 
            ),
          );
        },
      ),
    );
  } 

  void _sendMessage (
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

    var newMessageEvent = _messageNeededToBeSent.copyWith(
      timeDeleted: timeDeleted,
      forwardMessage: forwardMessage
    );

    chatBloc.add(newMessageEvent);
    _messageNeededToBeSent = null;
  }


  void _didSelectMediaOption (ChatBottomPanelTypes type) {
    if (type == ChatBottomPanelTypes.map) {
      _navigator.push(MapScreen.route(delegate: this));
    } else if (type == ChatBottomPanelTypes.contact) {
      _navigator.push(ChooseContactsPage.route(this, isSingleSelect: true));
    }
  }

  // MARK: - Delegates

  @override
  void didSelectCoordinates(PositionAddress positionAddress) {
    _messageNeededToBeSent = MessageSend(
      location: positionAddress.position,
      address: positionAddress.description
    );

    if (chatBloc.state.isSecretModeOn) {
      _navigator.push(TimePickerScreen.route(this));
    } else {
      _sendMessage(_panelBloc.state);
    }
  } 

  @override
  void didSelectTimeOption(TimeOptions option) {
    _sendMessage( 
      _panelBloc.state, 
      timeDeleted: option.seconds
    );
  }

  @override
  void didSaveContacts(List<ContactEntity> contacts) {
    var contact = contacts.getItemAt(0);

    _messageNeededToBeSent = MessageSend(
      contact: MessageUser(
        id: contact.id,
        name: contact.name,
        surname: contact.surname,
        avatarURL: contact.avatar,
        phone: ''
      )
    );

    if (chatBloc.state.isSecretModeOn) {
      _navigator.push(TimePickerScreen.route(this));
    } else {
      _sendMessage(_panelBloc.state);
    }
  }
}

