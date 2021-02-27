import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_view_model.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import 'package:messenger_mobile/modules/chats/presentation/widgets/categories_bloc_listener.dart';
import 'package:messenger_mobile/modules/chats/presentation/widgets/chat_item/chat_preview_item.dart';
import '../bloc/cubit/chats_cubit_cubit.dart';


class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {

  @override
  void initState() {
    var cubit = context.read<ChatsCubit>();
    cubit.loadAllChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ChatsCubit>();
    
    return Scaffold(
      appBar: _buildAppBar(
        ChatViewModel(cubit.selectedChat),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-home.png'),
            fit: BoxFit.cover
          )
        ),
        child: BlocConsumer<ChatsCubit, ChatsCubitState>(
          listener: (context, state) {
            _handleChatsUpdates(state);
          },
          builder: (context, state) {      
            return BlocConsumer<ChatsCubit, ChatsCubitState>(
              listener: (context, chatState) {},
              builder: (context, chatState) {
                return ListView.separated(
                  itemBuilder: (context, int index) {
                    if (index == 0) {
                      return ChatScreenCategoriesView(
                        chatsState: state,
                      );
                    } else if (!(chatState is ChatsCubitLoading)) {
                      return GestureDetector(
                        onLongPressStart: (d) {
                          cubit.didSelectChat(index - 1);
                        },
                        child: ChatPreviewItem(
                          ChatViewModel(
                            chatState.chats.data[index - 1],
                            isSelected: cubit.selectedChatIndex != null 
                              && cubit.selectedChatIndex == index - 1
                          )
                        ),
                      );
                    } else {
                      return CellShimmerItem();
                    }
                  },
                  itemCount: chatState is ChatsCubitLoading ? 10 :
                    chatState.chats.data.length + 1,
                  separatorBuilder: (context, int index) {
                    return _buildSeparators(index);
                  }
                );
              },
            );
          },
        ),
      )
    );
  }

  // * * Methods

  void _handleChatsUpdates (ChatsCubitState state) {
    if (state is ChatsCubitError) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage,
          style: TextStyle(color: Colors.red)),
        ), // SnackBar
      );
    }
  }

  Widget _buildSeparators (int index) {
    if (index == 0) {
      return Container();
    } else {
      return Container(
        height: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Divider(color: Colors.grey,),
      );
    }
  }

  AppBar _buildAppBar (ChatViewModel selectedChat) {
    var isSelected = selectedChat != null;

    return AppBar(
      title: Text(
        !isSelected ? 'Главная' : 'Выбрано: 1'
      ),
      leading: isSelected ? IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          context.read<ChatsCubit>().didCancelChatSelection();
        },
      ) : null,
    );
  }
}
