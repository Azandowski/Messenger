import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../../../app/appTheme.dart';
import '../../../../../app/application.dart';
import '../../../../../core/blocs/chat/bloc/bloc/chat_cubit.dart';
import '../../../../../core/widgets/independent/buttons/bottom_action_button.dart';
import '../../../../../locator.dart';
import '../../../../chat/presentation/chats_screen/pages/chat_screen_helper.dart';
import '../../../../chats/presentation/pages/chats_search_screen.dart';
import '../../../data/models/chat_view_model.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../create_category_main/widgets/chat_list.dart';
import 'cubit/chat_select_cubit.dart';

abstract class ChatChooseDelegate {
  void didSaveChats(List<ChatEntity> chats);
}

class ChooseChatsPage extends StatefulWidget {

  static Route route(
    ChatChooseDelegate delegate, { 
      String actionText,
      List<ChatEntity> excludeChats
    }) {
    return MaterialPageRoute<void>(builder: (_) => 
      ChooseChatsPage(
        delegate: delegate,
        actionText: actionText ?? 'Добавить чаты',
        excludeChats: excludeChats ?? []
    ));
  }

  final String actionText;
  final ChatChooseDelegate delegate;
  final List<ChatEntity> excludeChats;

  ChooseChatsPage({
    @required this.delegate,
    this.excludeChats,
    this.actionText = 'Добавить чаты',
    Key key,
  }) : super(key: key);

  @override
  _ChooseChatsPageState createState() => _ChooseChatsPageState();
}

class _ChooseChatsPageState extends State<ChooseChatsPage> implements ChatsSearchDelegate {
  
  ChatSelectCubit _chatSelectCubit;
  AutoScrollController scrollController = AutoScrollController();
  ChatGlobalCubit _cubit;
  List<ChatEntity> customEntities = [];
  NavigatorState get _navigator => sl<Application>().navKey.currentState;

  // * * Life-Cycle
  @override
  void initState() {

    _chatSelectCubit = ChatSelectCubit();

    _cubit = context.read<ChatGlobalCubit>();
    
    if (_cubit.state.currentCategory != 0 && _cubit.state.currentCategory != null) {
      
      // Load All Chats
      _cubit.loadChats(isPagination: false);
    }

    scrollController.addListener(() {
      if (scrollController.isPaginated && !_cubit.state.hasReachedMax && !(_cubit.state is ChatLoading)) {
        _cubit.loadChats(isPagination: true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // * * UI

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _chatSelectCubit,
      child: BlocConsumer<ChatGlobalCubit, ChatState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<ChatSelectCubit, ChatSelectState>(
            builder: (context, selectState) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Выбрано: ${selectState.selectedChats.length}'),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _navigator.push(ChatsSearchScreen.route(
                          delegate: this,
                          interactionType: ChatInteractionType.delegateMethod,
                          designStyle: ChatDesignStyle.onlyChats
                        ));
                      },
                    )
                  ],
                ),
                body: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Container(
                            child: Text(
                              'Выберите те чаты, которые вы хотите добавить',
                              style: AppFontStyles.placeholderStyle,
                            ),
                          ),
                        ),
                        returnStateWidget(state, context, selectState),
                        SizedBox(height: 40,)
                      ],
                    ),
                    BottomActionButtonContainer(
                      onTap: () {
                        Navigator.pop(context);
                        widget.delegate.didSaveChats(selectState.selectedChats);
                      }, 
                      title: widget.actionText
                    )
                  ],
                )
              );
            },
          );
        },
      ),
    );
  }

  Widget returnStateWidget(state, context, ChatSelectState selectState){
    var chatEntities = assignEntities(state.chats, selectState.selectedChats);
    return ChatsList(
      scrollController: scrollController,
      items: chatEntities,
      cellType: ChatCellType.addChat,
      onSelect: (ChatViewModel chatViewModel) {
        _chatSelectCubit.addChat(chatViewModel);
      },
      itemsCount: chatEntities.length + (state is ChatLoading ? 4 : 0),
      isAutoScrollable: true
    );
  }

  // * * Methods

  List<ChatViewModel> assignEntities (List<ChatEntity> entities, List<ChatEntity> selectedChats) {
    List<ChatEntity> total = [...customEntities, ...entities];
    
    return total
      .where((e) => (widget.excludeChats ?? []).indexWhere((i) => i.chatId == e.chatId) == -1)
      .map(
        (e) { 
          var index = selectedChats.indexWhere((element) => element.chatId == e.chatId);
          return ChatViewModel(e, isSelected: index != -1);
        }
      ).toList();
  }

  @override
  void didSelectChatItem(ChatEntity entity) {
    Navigator.of(context).pop();
    var item = ChatViewModel(entity, isSelected: true);
    var index = _cubit.state.chats.indexWhere((e) => e.chatId == entity.chatId);
    if (index == -1) {
      customEntities.insert(0, entity);
      setState(() {
        customEntities.insert(0, entity);
      });
    } else {
      scrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
    }
  }
}

