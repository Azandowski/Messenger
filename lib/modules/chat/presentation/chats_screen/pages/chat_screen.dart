import 'package:messenger_mobile/modules/chat/domain/entities/chat_actions.dart';

import '../widgets/remove_dialog_view.dart';

import '../../../../../core/blocs/chat/bloc/bloc/chat_cubit.dart' as main_chat_cubit;
import 'chat_screen_import.dart';


class ChatScreen extends StatefulWidget {
  final ChatEntity chatEntity;

  const ChatScreen({Key key, @required this.chatEntity}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> implements TimePickerDelegate {

  NavigatorState get _navigator => navigatorKey.currentState;
  
  // MARK: - Props

  TextEditingController messageTextController = TextEditingController();
  CategoryBloc categoryBloc;
  ChatBloc _chatBloc;
  PanelBlocCubit _panelBlocCubit;
  ChatTodoCubit _chatTodoCubit;
  
  // MARK: - Life-Cycle
  
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

    _chatTodoCubit = ChatTodoCubit(
      deleteMessageUseCase: DeleteMessage(repository: chatRepository),
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


  // MARK: - UI

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;
    ChatViewModel chatViewModel = ChatViewModel(widget.chatEntity);

    return BlocProvider(
      lazy: false,
      create: (context) => _chatTodoCubit,
      child: BlocBuilder<ChatTodoCubit, ChatTodoState>(
        builder: (context, cubit) {
          return BlocProvider(
            create: (context) => _chatBloc,
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                _handleListener(state);
              },
              builder: (context, state) {
                return Scaffold(
                  appBar: cubit is ChatTodoSelection ? SelectionAppBar(
                      chatViewModel: chatViewModel, 
                      widget: widget, 
                      delegate: this,
                      chatTodoCubit: _chatTodoCubit,
                      appBar: AppBar(),
                    ) : ChatAppBar(
                      chatViewModel: chatViewModel, 
                      navigator: _navigator, 
                      widget: widget, 
                      delegate: this,
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
                            decoration: BoxDecoration(
                            image: DecorationImage(
                              image: state.wallpaperPath != null ? 
                                FileImage(File(state.wallpaperPath)) : 
                                  AssetImage('assets/images/bg-home.png'),
                              fit: BoxFit.cover),
                            ),
                            child: ListView.separated(
                              controller: _chatBloc.scrollController,
                              itemBuilder: (context, int index) {
                                if (state is ChatLoading && getItemsCount(state) - 1 == index) {
                                  return LoadWidget(size: 20);
                                } else if (getItemsCount(state) - 1 == index) {
                                  if (state.messages.getItemAt(index - 1) != null) {
                                    return ChatActionView(
                                      chatAction: TimeAction(
                                        action: ChatActions.newDay,
                                        dateTime: state.messages[index - 1].dateTime
                                      )
                                    );
                                  }

                                  return Container();
                                } else {
                                  int nextMessageUserID = state.messages.getItemAt(index - 1)?.user?.id;
                                  int prevMessageUserID = state.messages.getItemAt(index + 1)?.user?.id;
                                  Message currentMessage = state.messages[index];
                                  bool isSelected = false;
                                  
                                  if (cubit is ChatTodoSelection) {
                                    isSelected = cubit.selectedMessages
                                      .where((element) => element.id == currentMessage.id)
                                      .toList().length > 0;
                                  }

                                  return currentMessage.chatActions == null ? 
                                    MessageCell(
                                      nextMessageUserID: nextMessageUserID,
                                      prevMessageUserID: prevMessageUserID,
                                      onReply: (MessageViewModel message){
                                        _panelBlocCubit.addMessage(message);
                                      },
                                      onAction: (MessageCellActions action){
                                        messageActionProcess(action, context, MessageViewModel(currentMessage));
                                      },
                                      messageViewModel: MessageViewModel(
                                        currentMessage,
                                        isSelected: isSelected,
                                      ),
                                      onTap: () {
                                        if (cubit is ChatTodoSelection) {
                                          if (isSelected) {
                                            _chatTodoCubit.removeMessage(currentMessage);
                                          } else {
                                            _chatTodoCubit.selectMessage(currentMessage);
                                          }
                                        }
                                      },
                                    ) : ChatActionView(
                                      chatAction: _buildChatAction(currentMessage)
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
                        ),
                        cubit is ChatTodoSelection || cubit is ChatToDoLoading ? 
                          Container(
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB(16,8,16,8),
                          child: ActionButton(
                            isLoading: cubit is ChatToDoLoading,
                            text: cubit.isDelete ? 'Удалить' : 'Переслать',
                            onTap: () {
                              if (cubit.isDelete) {
                                showDialog(context: context, builder: (ctx) {
                                  return DeleteDialogView(onDelete: (forMe){
                                    _chatTodoCubit.deleteMessage(
                                      chatID: widget.chatEntity.chatId,
                                      forMe: forMe
                                    );
                                  });
                                });
                              } else {
                              
                              }
                            },
                          ),
                        ) : ChatControlPanel(
                              messageTextController: messageTextController, 
                              width: width,
                              height: height
                            ),
                      ],
                    ),
                  ),
                );
              }
            )
          );
        },
      )
    );
  }



  // MARK: - Actions

  Future<void> messageActionProcess(
    MessageCellActions action, 
    BuildContext context, 
    MessageViewModel messageViewModel
  ) async {
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
        _chatTodoCubit.enableSelectionMode(messageViewModel.message, false);
        break;
      case MessageCellActions.deleteMessage:
        _chatTodoCubit.enableSelectionMode(messageViewModel.message, true);
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

  // Get Chat Action model from the message 
  ChatAction _buildChatAction (Message message) {
    if (message.chatActions.actionType == ChatActionTypes.group) {
      return GroupAction(
        firstUser: message.user,
        action: message.chatActions,
        secondUser: message.toUser
      );
    } else {
      return null;
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
        return ChatActionView(
          chatAction: TimeAction(
            dateTime: state.messages[index].dateTime,
            action: ChatActions.newDay
          )
        );
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

