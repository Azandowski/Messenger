import 'package:flutter/rendering.dart';
import 'package:messenger_mobile/app/application.dart';
import 'package:messenger_mobile/modules/category/presentation/chooseChats/presentation/chat_choose_page.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_actions.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/attachMessage.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/disattachMessage.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_messages_context.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/bottom_pin.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/reply_more.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'chat_screen_import.dart';
import 'chat_screen_helper.dart';

class ChatScreen extends StatefulWidget {
  final ChatEntity chatEntity;
  
  // Non-Null if have to show region of the message 
  final int messageID;

  const ChatScreen({
    @required this.chatEntity,
    this.messageID,
    Key key, 
  }) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> implements ChatChooseDelegate{

  NavigatorState get _navigator => sl<Application>().navKey.currentState;
  
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
      context: context,
      deleteMessageUseCase: DeleteMessage(repository: chatRepository),
      attachMessageUseCase: AttachMessage(repository: chatRepository),
      disAttachMessageUseCase: DisAttachMessage(repository: chatRepository),
      replyMoreUseCase: ReplyMore(repository: chatRepository)
    );
    
    categoryBloc = context.read<CategoryBloc>();
    _panelBlocCubit = PanelBlocCubit();
    _chatBloc = ChatBloc(
      chatId: widget.chatEntity.chatId,
      chatRepository: chatRepository,
      sendMessage: SendMessage(repository: chatRepository),
      getMessages: GetMessages(repository: chatRepository),
      getMessagesContext: GetMessagesContext(repository: chatRepository),
      chatsRepository: sl(),
      setTimeDeleted: SetTimeDeleted(repository: chatRepository)
    )..add(LoadMessages(
      isPagination: false,
      messageID: widget.messageID,
    ));

    _chatBloc.scrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
        Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical
    );

    _chatBloc.scrollController.addListener(() {
      this.handleScrollControllerChanges(_chatBloc);
    });

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
                handleListener(
                  state, 
                  scrollController: _chatBloc.scrollController, 
                  todoCubit: _chatTodoCubit
                );
              },
              builder: (context, state) {
                return Scaffold(
                  appBar: this.buildAppBar(
                    _chatTodoCubit, cubit, chatViewModel, _navigator,
                  ),
                  floatingActionButton: shouldShowBottomPin(state) ?
                    BottomPin(
                      state: state,
                      onPress: () {
                        _chatBloc.add(LoadMessages(
                          isPagination: false,
                          resetAll: true
                        ));
                      }
                    ) : null,
                  backgroundColor: AppColors.pinkBackgroundColor,
                  body: BlocProvider(
                    lazy: false,
                    create: (context) => _panelBlocCubit,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if(state.topMessage != null) this.buildTopMessage(state,
                          width, height, _chatTodoCubit,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: this.getBackground(state)
                            ),
                            child: ListView.separated(
                              key: PageStorageKey('feed'),
                              // physics: CustomBouncingScrollPhysics(),
                              controller: _chatBloc.scrollController,
                              itemBuilder: (context, int index) {
                                var spinnerIndex;
                                if (state is ChatLoading) {
                                  spinnerIndex = state.direction == null || state.direction == RequestDirection.top ? 
                                    getItemsCount(state) - 1 : 0;
                                }

                                if (state is ChatLoading && spinnerIndex == index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: LoadWidget(size: 20)
                                  );
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
                                  var indexMinus = 0;
                                  if (state is ChatLoading) {
                                    if (!(state.direction == null || state.direction == RequestDirection.top)) {
                                      indexMinus = 1;
                                    }
                                  }
                                  int currentIndex = index - indexMinus;
                                  int nextMessageUserID = state.messages.getItemAt(currentIndex - 1)?.user?.id;
                                  int prevMessageUserID = state.messages.getItemAt(currentIndex + 1)?.user?.id;
                                  Message currentMessage = state.messages[currentIndex];
                                  bool isSelected = false;
                                  
                                  if (cubit is ChatTodoSelection) {
                                    isSelected = cubit.selectedMessages
                                      .where((element) => element.id == currentMessage.id)
                                      .toList().length > 0;
                                  }

                                  final body = currentMessage.chatActions == null ? 
                                    MessageCell(
                                      nextMessageUserID: nextMessageUserID,
                                      prevMessageUserID: prevMessageUserID,
                                      onReply: (MessageViewModel message){
                                        _panelBlocCubit.addMessage(message);
                                      },
                                      onAction: (MessageCellActions action){
                                        messageActionProcess(
                                          action, context, 
                                          MessageViewModel(currentMessage), 
                                          _panelBlocCubit, _chatTodoCubit
                                        );
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

                                  return AutoScrollTag(
                                    key: ValueKey(index),
                                    controller: _chatBloc.scrollController,
                                    index: index,
                                    child: body
                                  );
                                }
                              },
                              scrollDirection: Axis.vertical,
                              itemCount: getItemsCount(state),
                              reverse: true,
                              separatorBuilder: (_, int index) {
                                return buildSeparator(index, state);
                              }
                            ),
                          ),
                        ),
                        this.buildChatBottom(
                          cubit, _chatTodoCubit, 
                          width, height
                        )
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


  // * * Helpers

  int getItemsCount (ChatState state) {
    return state.messages.length + 1;
  }

  bool shouldShowBottomPin (ChatState state) {
    return (state.unreadCount != null && state.unreadCount != 0) ||
      (state.showBottomPin != null && state.showBottomPin) || 
        !state.hasReachBottomMax;
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


  @override
  void didSelectTimeOption(TimeOptions option) {
    Navigator.of(context).pop();
    _chatBloc.add(SetInitialTime(option: option));
  }

  @override
  void didSaveChats(List<ChatEntity> chats) {
   _chatTodoCubit.replyMessageToMore(chatIds: chats);
  }
}

