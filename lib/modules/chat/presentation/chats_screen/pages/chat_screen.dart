import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/widgets/independent/placeholders/load_widget.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chat/data/datasources/chat_datasource.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_view_model.dart';
import 'package:messenger_mobile/modules/chat/data/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_messages.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/send_message.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/page/chat_detail_page.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/bloc/chat_bloc.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chatControlPanel/chatControlPanel.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chatControlPanel/cubit/panel_bloc_cubit.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chatHeading.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chat_date_item.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chat_screen_actions.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/message_cell.dart';
import 'package:messenger_mobile/core/utils/list_helper.dart';
import '../../../../../main.dart';
import 'package:intl/intl.dart';


class ChatScreen extends StatefulWidget {
  final ChatEntity chatEntity;

  const ChatScreen({Key key,@required this.chatEntity}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  NavigatorState get _navigator => navigatorKey.currentState;
  
  TextEditingController messageTextController = TextEditingController();
     
  ChatBloc _chatBloc;
  PanelBlocCubit _panelBlocCubit;
  @override
  void initState() {
    final ChatRepository chatRepository = ChatRepositoryImpl(
      networkInfo: sl(),
      chatDataSource: ChatDataSourceImpl(
        id: widget.chatEntity.chatId,
        socketService: sl(),
        client: sl()
      )
    );
    _panelBlocCubit = PanelBlocCubit();
    _chatBloc = ChatBloc(
      chatId: widget.chatEntity.chatId,
      chatRepository: chatRepository,
      sendMessage: SendMessage(repository: chatRepository),
      getMessages: GetMessages(repository: chatRepository)
    )..add(LoadMessages(isPagination: true));
    super.initState();
  }

  @override
  void dispose() {
    _chatBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;
    
    return BlocProvider(
      lazy: false,
      create: (context) => _panelBlocCubit,
      child: BlocProvider(
          lazy: false,
          create: (context) => _chatBloc,
          child: BlocConsumer<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is ChatError) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
              }
            },
            
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: false,
                  titleSpacing: 0.0,
                  title: ChatHeading(
                    title: widget.chatEntity.title ?? '',
                    description: widget.chatEntity.description ?? '',
                    avatarURL: widget.chatEntity.imageUrl,
                    onTap: () {
                      _navigator.push(ChatDetailPage.route(widget.chatEntity.chatId));
                    }
                  ),
                  actions: [
                    ChatScreenActions()
                  ],
                ),
                backgroundColor: AppColors.pinkBackgroundColor,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/bg-home.png'),
                          fit: BoxFit.cover),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: ListView.separated(
                            controller: _chatBloc.scrollController,
                            itemBuilder: (context, int index) {
                              if (state is ChatLoading && getItemsCount(state) - 1 == index) {
                                return LoadWidget(size: 20);
                              } else if (getItemsCount(state) - 1 == index) {
                                var item = state.messages.getItemAt(index);
                                if (state.messages.getItemAt(index - 1) != null) {
                                  return ChatDateItem(
                                    dateTime: state.messages[index - 1].dateTime
                                  );
                                } 
                                return Container();
                              } else {
                                int nextMessageUserID = state.messages.getItemAt(index - 1)?.user?.id;
                                int prevMessageUserID = state.messages.getItemAt(index + 1)?.user?.id;
                                Message currentMessage = state.messages[index];
                                
                                return currentMessage.chatActions == null ? 
                                  MessageCell(
                                    onReply: (MessageViewModel message){
                                      _panelBlocCubit.addMessage(message);
                                    },
                                    messageViewModel: MessageViewModel(currentMessage),
                                    nextMessageUserID: nextMessageUserID,
                                    prevMessageUserID: prevMessageUserID,
                                  ) : Text('action');
                              }
                            },
                        scrollDirection: Axis.vertical,
                        itemCount: getItemsCount(state),
                        reverse: true,
                        separatorBuilder: (_, int index) {
                          return _buildSeparator(index, state);
                        }
                      ),
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
      ),
     ),
    );
  }


  // * * Helpers

  int getItemsCount (ChatState state) {
    return state.messages.length + 1;
  }


  Widget _buildSeparator (int index, ChatState state) {
    if (!(state is ChatLoading && getItemsCount(state) - 1 == index)) {
      Message nextMessage = state.messages.getItemAt(index + 1);

      if (
        nextMessage != null && 
        nextMessage.dateTime?.day != null && 
        state.messages[index].dateTime?.day != null && 
        nextMessage.dateTime?.day != state.messages[index].dateTime?.day
      ) {
        return ChatDateItem(dateTime: state.messages[index].dateTime,);
      } 
    } 
 
    return Container();
  }
}