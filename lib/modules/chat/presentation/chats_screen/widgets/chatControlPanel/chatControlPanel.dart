import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/bloc/chat_bloc.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chatControlPanel/panel_bloc.dart';
import 'package:provider/provider.dart';

class ChatControlPanel extends StatefulWidget {
  const ChatControlPanel({
    Key key,
    @required this.messageTextController,
    @required this.width,
    @required this.height,
  }) : super(key: key);

  final TextEditingController messageTextController;
  final double width;
  final double height;

  @override
  _ChatControlPanelState createState() => _ChatControlPanelState();
}

class _ChatControlPanelState extends State<ChatControlPanel> {

  PanelBloc _panelBloc = PanelBloc();
  ChatBloc _chatBloc;
  
  @override
  void initState() {
    super.initState();
    _chatBloc = context.read<ChatBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
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
                        color: Colors.white),
                        onPressed: () {
                          if (!textStream.hasError) {
                            _panelBloc.clear();
                            widget.messageTextController.clear();
                            _chatBloc.add(MessageSend(message: textStream.data));
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
    );
  }
}