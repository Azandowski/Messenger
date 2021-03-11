import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/bloc/chat_bloc.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chatControlPanel/cubit/panel_bloc_cubit.dart';
import 'package:provider/provider.dart';

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

class _ChatControlPanelState extends State<ChatControlPanel> {

  PanelBlocCubit _panelBloc;
  ChatBloc _chatBloc;
  
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
              child:Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<PanelBlocCubit, PanelBlocState>(
                    builder: (context, state) {
                      return state is PanelBlocReplyMessage ?
                        ReplyContainer(
                          cubit: _panelBloc,
                        ) : SizedBox(height: 4,);
                    },
                  ),
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
                ],
              ),
          )
        );

  }
}

class ReplyContainer extends StatelessWidget {
  final PanelBlocCubit cubit;
  const ReplyContainer({
    Key key,
    @required this.cubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var messageVM = (cubit.state as PanelBlocReplyMessage).messageViewModel;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 16, bottom: 8, top: 8),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: AppColors.indicatorColor,
              width: 2,
              height: 55,
            ),
            SizedBox(width: 8,),
            Expanded(
                child: Column( 
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      messageVM.isMine ? 'Вы' : 
                      messageVM.userNameText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        color: messageVM.color,
                      ),
                    ),
                    Container(
                      child: Text(messageVM.messageText,
                        style: AppFontStyles.black14w400,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                      ),
                    ),
                ],
          ),
            ),
          IconButton(icon: Icon(Icons.close), onPressed: (){
            cubit.detachMessage();
          })
      ],
    ),
  ),
  );
  }
}