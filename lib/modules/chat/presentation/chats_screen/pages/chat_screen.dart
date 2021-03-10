import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chat/data/datasources/chat_datasource.dart';
import 'package:messenger_mobile/modules/chat/data/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/send_message.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/page/chat_detail_page.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/bloc/chat_bloc.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chatControlPanel/chatControlPanel.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chatHeading.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/message_cell.dart';

import '../../../../../main.dart';


class ChatScreen extends StatefulWidget {
  final ChatEntity chatEntity;

  const ChatScreen({Key key,@required this.chatEntity}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  NavigatorState get _navigator => navigatorKey.currentState;
  
  TextEditingController messageTextController = TextEditingController();
     
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;
    final ChatRepository chatRepository = ChatRepositoryImpl(
      networkInfo: sl(),
      chatDataSource: ChatDataSourceImpl(
        id: widget.chatEntity.chatId,
        socketService: sl(),
        client: sl())
      );
    return BlocProvider(
      lazy: false,
      create: (context) => ChatBloc(
        chatId: widget.chatEntity.chatId,
        chatRepository: chatRepository,
          sendMessage: SendMessage(repository: chatRepository)
        ),
      child:  BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              titleSpacing: 0.0,
              title: ChatHeading(onTap: (){
                _navigator.push(ChatDetailPage.route(widget.chatEntity.chatId));
              },),
              actions: [
              Row(children: [
                IconButton(icon: Icon(Icons.video_call,color: AppColors.indicatorColor,),onPressed: (){
    
                },),
                IconButton(icon: Icon(Icons.call,color: AppColors.indicatorColor,),onPressed: (){
    
                },),
                IconButton(icon: Icon(Icons.more_vert_rounded,color: AppColors.indicatorColor,),onPressed: (){
    
                  },)
                ],)
              ],),
            backgroundColor: AppColors.pinkBackgroundColor,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: 
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/images/bg-home.png'),
                      fit: BoxFit.cover),
                    ),
                    child: ListView.builder(
                      itemBuilder: (context, i) {
                        return state.messages.reversed.toList()[i].chatActions == null ? 
                          MessageCell(message: state.messages[i]) : Text('action');
                      },
                      scrollDirection: Axis.vertical,
                      itemCount: state.messages.length,
                      reverse: true,
                    ),
                  ),
                ),
                ChatControlPanel(
                  messageTextController: messageTextController, 
                  width: width,
                  height: height
                ),
              ],
            ),
          );
        }
      )
    );
  }
}


