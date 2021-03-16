import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  static Route route(ChatChooseDelegate delegate) {
    return MaterialPageRoute<void>(builder: (_) => ChooseChatsPage(delegate: delegate,));
  }

  final ChatChooseDelegate delegate;
  
  ChooseChatsPage({
    @required this.delegate,
    Key key,
  }) : super(key: key);

  @override
  _ChooseChatsPageState createState() => _ChooseChatsPageState();
}

class _ChooseChatsPageState extends State<ChooseChatsPage> {
  
  // * * Props
  
  int _chatsCount = 0;
  List<ChatViewModel> chatEntities = [];

  // * * Life-Cycle

  @override
  void initState() {
    ChatGlobalCubit _cubit = context.read<ChatGlobalCubit>();
    if (_cubit.state.currentCategory != 0 && _cubit.state.currentCategory != null) {
      
      // Load All Chats
      _cubit.loadChats(isPagination: false);
    }

    if (_cubit.state is ChatsLoaded) {
      assignEntities((_cubit.state as ChatsLoaded).chats);
    }

    super.initState();
  }

  // * * UI

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatGlobalCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatsLoaded) {
          assignEntities(state.chats);
          _chatsCount = chatEntities.where((e) => e.isSelected).toList().length;
        } 
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Выбрано: $_chatsCount'),
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
                  returnStateWidget(state, context),
                ],
              ),
              if (state is ChatsLoaded)  
                Positioned(
                  bottom: 40,
                  child: ActionButton(
                    text: 'Добавить чаты', 
                    onTap: () {
                      List<ChatEntity> selectedChats = [];
                      if (state is ChatsLoaded) {
                        selectedChats = chatEntities.where((e) => e.isSelected).map((e) => e.entity).toList();
                      }

                      widget.delegate.didSaveChats(selectedChats);
                      Navigator.pop(context);
                    }
                  ),
                ),
            ],
          )
       );
     }
    );
  }

  Widget returnStateWidget(state, context){
    if (state is ChatsLoaded) {
      return ChatsList(
        items: chatEntities,
        cellType: ChatCellType.addChat,
        onSelect: (ChatEntity chatEntity) {
          var index = chatEntities.indexWhere((e) => e.entity.chatId == chatEntity.chatId);
          if (index != null) {
            setState(() {
              chatEntities[index].isSelected = !chatEntities[index].isSelected;
            });
          }
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

  void assignEntities (List<ChatEntity> entities) {
    chatEntities = entities.map(
      (e) => ChatViewModel(e)
    ).toList();
  }
}

