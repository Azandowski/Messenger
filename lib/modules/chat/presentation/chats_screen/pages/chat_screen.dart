import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/blocs/category/bloc/category_bloc.dart';
import 'package:messenger_mobile/core/blocs/chat/bloc/bloc/chat_cubit.dart' as main_chat_cubit;
import 'package:messenger_mobile/core/widgets/independent/placeholders/load_widget.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_view_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chat/data/datasources/chat_datasource.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_view_model.dart';
import 'package:messenger_mobile/modules/chat/data/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_actions.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_messages.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/send_message.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/set_time_deleted.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/bloc/chat_bloc.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/helpers/messageCellAction.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chatControlPanel/chatControlPanel.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chatControlPanel/cubit/panel_bloc_cubit.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chat_action_view.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chat_app_bar.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chat_date_item.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/message_cell.dart';
import 'package:messenger_mobile/core/utils/list_helper.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/selection_app_bar.dart';
import 'package:messenger_mobile/modules/chat/presentation/time_picker/time_picker_screen.dart';
import '../../../../../main.dart';


class ChatScreen extends StatefulWidget {
  final ChatEntity chatEntity;

  const ChatScreen({Key key, @required this.chatEntity}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> implements TimePickerDelegate {

  NavigatorState get _navigator => navigatorKey.currentState;
  
  TextEditingController messageTextController = TextEditingController();
  CategoryBloc categoryBloc;
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
    categoryBloc = context.read<CategoryBloc>();
    _panelBlocCubit = PanelBlocCubit();
    _chatBloc = ChatBloc(
      chatId: widget.chatEntity.chatId,
      chatRepository: chatRepository,
      sendMessage: SendMessage(repository: chatRepository),
      getMessages: GetMessages(repository: chatRepository),
      chatsRepository: sl(),
      setTimeDeleted: SetTimeDeleted(repository: chatRepository)
    )..add(LoadMessages(isPagination: true));
    super.initState();
  }

  @override
  void dispose() {
    _chatBloc.add(DisposeChat());
    _chatBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;
    ChatViewModel chatViewModel = ChatViewModel(widget.chatEntity);

    return BlocProvider(
      create: (context) => _chatBloc,
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          _handleListener(state);
        },
        builder: (context, state) {
          return Scaffold(
            appBar: state is ChatSelection ? SelectionAppBar(
              chatViewModel: chatViewModel, widget: widget, delegate: this,
              chatBloc: _chatBloc,
              appBar: AppBar(),
            ) : ChatAppBar(
              chatViewModel: chatViewModel, navigator: _navigator, widget: widget, delegate: this,
              appBar: AppBar(),
            ),
            backgroundColor: AppColors.pinkBackgroundColor,
            body: BlocProvider(
              lazy: false,
              create: (context) => _panelBlocCubit,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                      image: DecorationImage(
                        image: state.wallpaperPath != null ? 
                          FileImage(File(state.wallpaperPath)) : 
                            AssetImage('assets/images/bg-home.png'),
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
                                  onAction: (MessageCellActions action){
                                    messageActionProcess(action, context, MessageViewModel(currentMessage));
                                  },
                                  messageViewModel: MessageViewModel(currentMessage),
                                  nextMessageUserID: nextMessageUserID,
                                  prevMessageUserID: prevMessageUserID,
                                ) : ChatActionView(
                                  chatActions: currentMessage.chatActions
                                );
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
                )   ,
              ),
              ChatControlPanel(
                messageTextController: messageTextController, 
                width: width,
                height: height
              ),
            ],
          ),
        
       ),
      );}
    ));
  }

  Future<void> messageActionProcess(MessageCellActions action,BuildContext context, MessageViewModel messageViewModel) async {
    switch (action){
      case MessageCellActions.copyMessage:
        Clipboard.setData(ClipboardData(text: messageViewModel.messageText))
        ..then((result) {
          final snackBar = SnackBar(
            content: Text('Скопировано в буфер обмена'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
        break;
      case MessageCellActions.attachMessage:
        // TODO: Handle this case.
        break;
      case MessageCellActions.replyMessage:
        _panelBlocCubit.addMessage(messageViewModel);
        break;
      case MessageCellActions.replyMore:
        _chatBloc.add(EnableSelectMode());
        break;
      case MessageCellActions.deleteMessage:
        // TODO: Handle this case.
        break;
    }
  }

  // * * Helpers

  int getItemsCount (ChatState state) {
    return state.messages.length + 1;
  }

  void _handleListener (ChatState state) {
    if (state is ChatError) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(state.message)),
        );
    } else if (state is ChatLoadingSilently) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: LinearProgressIndicator(), 
          duration: Duration(days: 2),
        ));
    } else if (state is ChatInitial) {
      // Update Notification Badge

      var chatGlobalCubit = context.read<main_chat_cubit.ChatGlobalCubit>();
      var globalIndexOfChat = chatGlobalCubit.state.chats.indexWhere((e) => e.chatId == widget.chatEntity.chatId);

      if (globalIndexOfChat != -1) {
        if (chatGlobalCubit.state.chats[globalIndexOfChat].unreadCount != 0) {
          context.read<main_chat_cubit.ChatGlobalCubit>().resetChatNoReadCounts(chatId: widget.chatEntity.chatId);
          if (widget.chatEntity.chatCategory?.id != null) {

            int index = categoryBloc.state.categoryList.indexWhere((e) => e.id == widget.chatEntity.chatCategory?.id);

            categoryBloc.add(CategoryReadCountChanged(
              categoryID: widget.chatEntity.chatCategory?.id,
              newReadCount: categoryBloc.state.categoryList[index].noReadCount - 1
            ));
          }
        }
      }
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
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

  @override
  void didSelectTimeOption(TimeOptions option) {
    Navigator.of(context).pop();
    _chatBloc.add(SetInitialTime(option: option));
  }
}

