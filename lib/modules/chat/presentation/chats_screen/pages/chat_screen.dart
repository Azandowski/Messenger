import 'package:flutter/rendering.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/modules/chat/data/datasources/local_chat_datasource.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/open_chat_cubit/open_chat_cubit.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/open_chat_cubit/open_chat_listener.dart';
import 'package:messenger_mobile/modules/groupChat/domain/usecases/create_chat_group.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../../../app/application.dart';
import '../../../../../core/services/network/Endpoints.dart';
import '../../../../category/presentation/chooseChats/presentation/chat_choose_page.dart';
import '../../../domain/entities/chat_actions.dart';
import '../../../domain/usecases/attachMessage.dart';
import '../../../domain/usecases/disattachMessage.dart';
import '../../../domain/usecases/get_messages_context.dart';
import '../../../domain/usecases/reply_more.dart';
import '../widgets/bottom_pin.dart';
import 'chat_screen_helper.dart';
import 'chat_screen_import.dart';

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

  NavigatorState get navigator => sl<Application>().navKey.currentState;
  
  // MARK: - Props

  TextEditingController messageTextController = TextEditingController();
  CategoryBloc categoryBloc;
  ChatBloc _chatBloc;
  PanelBlocCubit _panelBlocCubit;
  ChatTodoCubit _chatTodoCubit;
  ChatRepository chatRepository;
  
  // MARK: - Life-Cycle
  
  @override
  void initState() {
    chatRepository = ChatRepositoryImpl(
      networkInfo: sl(),
      chatDataSource: ChatDataSourceImpl(
        id: widget.chatEntity.chatId,
        socketService: sl(),
        client: sl(),
        multipartRequest: http.MultipartRequest(
          'POST', Endpoints.sendMessages.buildURL(urlParams:  [widget.chatEntity.chatId.toString()])
        ),
      ),
      localChatDataSource: LocalChatDataSourceImpl()
    );

    _chatTodoCubit = ChatTodoCubit(
      context: context,
      deleteMessageUseCase: DeleteMessage(repository: chatRepository),
      attachMessageUseCase: AttachMessage(repository: chatRepository),
      disAttachMessageUseCase: DisAttachMessage(repository: chatRepository),
      replyMoreUseCase: ReplyMore(repository: chatRepository)
    );
    
    categoryBloc = context.read<CategoryBloc>();
    _chatBloc = ChatBloc(
      chatId: widget.chatEntity.chatId,
      chatRepository: chatRepository,
      sendMessage: SendMessage(repository: chatRepository),
      getMessages: GetMessages(repository: chatRepository),
      getMessagesContext: GetMessagesContext(repository: chatRepository),
      chatsRepository: sl(),
      setTimeDeleted: SetTimeDeleted(repository: chatRepository),
      isSecretModeOn: widget.chatEntity?.permissions?.isSecret ?? false,
      chatEntity: widget.chatEntity,
    )..add(LoadMessages(
      isPagination: false,
      messageID: widget.messageID,
      isInitial: true
    ));

    _panelBlocCubit = PanelBlocCubit(
      getVideoUseCase: sl(),
      getImagesFromGallery: sl(),
      getAudios: sl(),
      getImage: sl(),
      chatBloc: _chatBloc,
    );

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
                    _chatTodoCubit, 
                    cubit, state, chatViewModel, navigator,
                    (ChatAppBarActions action) {
                      if (action == ChatAppBarActions.onOffSecretMode) {
                        _chatBloc.add(SetInitialTime(isOn: !(state?.isSecretModeOn ?? false)));
                      }
                    }
                  ),
                  floatingActionButton: shouldShowBottomPin(state) ?
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      child: BottomPin(
                        state: state,
                        onPress: () {
                          _chatBloc.add(LoadMessages(
                            isPagination: false,
                            resetAll: true,
                            direction: RequestDirection.bottom
                          ));
                        }
                      ),
                    ) :  null,
                  backgroundColor: AppColors.pinkBackgroundColor,
                  body: BlocProvider(
                    lazy: false,
                    create: (context) => _panelBlocCubit,
                    child: BlocProvider<OpenChatCubit>(
                      create: (context) => OpenChatCubit(
                        createChatGruopUseCase: sl<CreateChatGruopUseCase>()
                      ),
                      child: BlocConsumer<OpenChatCubit, OpenChatState>(
                        listener: (context, openChatState) {
                          OpenChatListener().handleStateUpdate(context, openChatState);
                        },
                        builder: (context, stopenChatStateate) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (state.topMessage != null) 
                                InkWell(
                                  onTap: () {
                                    _chatBloc.add(LoadMessages(
                                      messageID: state.topMessage.id,
                                      isPagination: false
                                    ));
                                  },
                                  child: this.buildTopMessage(state,
                                    width, height, _chatTodoCubit,
                                  ),
                                ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: this.getBackground(state),
                                    // color: Colors.red
                                  ),
                                  child: ListView.separated(
                                    key: PageStorageKey('feed'),
                                    controller: _chatBloc.scrollController,
                                    itemBuilder: (context, int index) => this.buildMessageCell(
                                      index: index, 
                                      state: state, 
                                      cubit: cubit, 
                                      panelBlocCubit: _panelBlocCubit, 
                                      chatTodoCubit: _chatTodoCubit, 
                                      chatBloc: _chatBloc,
                                      chatRepository: chatRepository
                                    ),
                                    cacheExtent: 40,
                                    scrollDirection: Axis.vertical,
                                    itemCount: getItemsCount(state),
                                    reverse: true,
                                    separatorBuilder: (_, int index) {
                                      return buildSeparator(index, state);
                                    }
                                  ),
                                ),
                              ),
                              if (canSendMessage(state))
                                this.buildChatBottom(
                                  cubit, _chatTodoCubit, 
                                  width, height,
                                  canSendMedia: canSendMedia(state),
                                  currentTimeOption: state.currentTimerOption,
                                  onLeadingIconTap: () {
                                    if (state.currentTimerOption != null) {
                                      _chatBloc.add(UpdateTimerOption(newTimerOption: null));
                                    }
                                  }
                                )
                            ],
                          );
                        },
                      ),
                    )
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
    return (state?.unreadCount != null && state.unreadCount != 0) ||
      (state?.showBottomPin != null && state?.showBottomPin) || 
        !state.hasReachBottomMax;
  }

  bool isAdmin (ChatState state) {
    return sl<AuthConfig>().user.id == state.chatEntity?.adminID;
  }

  bool canSendMessage (ChatState state) {
    return !(state.chatEntity.permissions?.adminMessageSend ?? false) || isAdmin(state);
  }

  bool canSendMedia (ChatState state) {
    print((state.chatEntity.permissions?.isMediaSendOn ?? true) || isAdmin(state));
    return (state.chatEntity.permissions?.isMediaSendOn ?? true) || isAdmin(state);
  }

  // Get Chat Action model from the message 
  ChatAction buildChatAction (Message message) {
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
    // _chatBloc.add(SetInitialTime(option: option));
  }

  @override
  void didSaveChats(List<ChatEntity> chats) {
   _chatTodoCubit.replyMessageToMore(chatIds: chats);
  }
}

