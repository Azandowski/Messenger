import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/modules/category/presentation/chooseChats/presentation/cubit/chat_select_cubit.dart';

import '../../../../../app/appTheme.dart';
import '../../../../../core/blocs/chat/bloc/bloc/chat_cubit.dart';
import '../../../../../core/widgets/independent/buttons/gradient_main_button.dart';
import '../../../../../core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import '../../../data/models/chat_view_model.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../create_category_main/widgets/chat_list.dart';

abstract class ChatChooseDelegate{
  void didSaveChats(List<ChatEntity> chats);
}

class ChooseChatsPage extends StatefulWidget {

  static Route route(ChatChooseDelegate delegate, {String actionText}) {
    return MaterialPageRoute<void>(builder: (_) => ChooseChatsPage(delegate: delegate,actionText: actionText ?? 'Добавить чаты',));
  }
  final String actionText;
  final ChatChooseDelegate delegate;
  
  ChooseChatsPage({
    @required this.delegate,
    this.actionText = 'Добавить чаты',
    Key key,
  }) : super(key: key);

  @override
  _ChooseChatsPageState createState() => _ChooseChatsPageState();
}

class _ChooseChatsPageState extends State<ChooseChatsPage> {
  
  // * * Life-Cycle
  ChatSelectCubit _chatSelectCubit;
  @override
  void initState() {

    _chatSelectCubit = ChatSelectCubit();

    ChatGlobalCubit _cubit = context.read<ChatGlobalCubit>();
    if (_cubit.state.currentCategory != 0 && _cubit.state.currentCategory != null) {
      
      // Load All Chats
      _cubit.loadChats(isPagination: false);
    }

    if (_cubit.state is ChatsLoaded) {

    }

    super.initState();
  }

  // * * UI

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _chatSelectCubit,
      child: BlocBuilder<ChatSelectCubit, ChatSelectState>(
        builder: (context, selectState) {
          return BlocConsumer<ChatGlobalCubit, ChatState>(
            listener: (context, state) {
              if (state is ChatsLoaded) {
                //TODO: ADD ChatViewModels when pagination cames to Cubit
              } 
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Выбрано: ${selectState.selectedChats.length}'),
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
                      ],
                    ),
                    if (state is ChatsLoaded)  
                      Positioned(
                        bottom: 40,
                        child: ActionButton(
                          text: widget.actionText, 
                          onTap: () {
                            widget.delegate.didSaveChats(selectState.selectedChats);
                            Navigator.pop(context);
                          }
                        ),
                      ),
                  ],
                )
              );
            }
          );
        },
      ),
    );
  }

  Widget returnStateWidget(state, context, ChatSelectState selectState){
    if (state is ChatsLoaded) {
      var chatEntities = assignEntities(state.chats, selectState.selectedChats);
      return ChatsList(
        items: chatEntities,
        cellType: ChatCellType.addChat,
        onSelect: (ChatViewModel chatViewModel) {
          _chatSelectCubit.addChat(chatViewModel);
        },
      );
    } else if (state is ChatLoading) {
      return Expanded(
        child: ListView.builder(
          itemBuilder: (context, int index) {
            return CellShimmerItem();
          },
          itemCount: 10,
        )
      );
    } else {
      return Text('default');
    }
  }

  // * * Methods

  List<ChatViewModel> assignEntities (List<ChatEntity> entities, List<ChatEntity> selectedChats) {
    return entities.map(
      (e) { 
        var index = selectedChats.indexWhere((element) => element.chatId == e.chatId);
        return ChatViewModel(e, isSelected: index != -1);
      }
    ).toList();
  }
}

