import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/app/application.dart';
import 'package:messenger_mobile/modules/chat/presentation/time_picker/time_picker_screen.dart';
import 'package:provider/provider.dart';

import '../../../../../../app/appTheme.dart';
import '../../../../../../locator.dart';
import '../../../../domain/entities/message.dart';
import '../../bloc/chat_bloc.dart';
import 'cubit/panel_bloc_cubit.dart';
import 'reply_container.dart';

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

class _ChatControlPanelState extends State<ChatControlPanel> implements TimePickerDelegate {

  PanelBlocCubit _panelBloc;
  ChatBloc _chatBloc;
  AsyncSnapshot<String> _lastTextStream;

  NavigatorState get _navigator => sl<Application>().navKey.currentState;

  @override
  void initState() {
    super.initState();
    _chatBloc = context.read<ChatBloc>();
    _panelBloc = context.read<PanelBlocCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pinkBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 4, blurRadius: 7,
            offset: Offset(0, -4), // changes position of shadow
          ),
        ],
      ),
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
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.emoji_emotions,
                                color: Colors.grey,
                              ),
                              Expanded(
                                child: TextFormField(
                                controller: widget.messageTextController,
                                onChanged: (String text) => _panelBloc.updateText(text),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                  horizontal: widget.width / (360 / 16), vertical: widget.height / (724 / 18)),
                                hintText: 'Сообщение',
                                labelStyle: AppFontStyles.blueSmallStyle)),
                              ),
                              Icon(Icons.attach_file,color: Colors.grey,),
                            ],
                          ),
                        )
                      ),
                      SizedBox(width: 5,),
                      StreamBuilder(
                        stream: _panelBloc.textStream,
                        builder: (context, AsyncSnapshot<String> textStream) {
                          return ClipOval(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: AppGradinets.mainButtonGradient,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  textStream.hasError ? Icons.mic : Icons.send,
                                  color: Colors.white
                                ),
                                onPressed: () {
                                  if (!textStream.hasError) {
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
          }
        )
      )
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

