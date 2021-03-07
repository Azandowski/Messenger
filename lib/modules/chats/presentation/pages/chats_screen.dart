import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/core/blocs/chat/bloc/bloc/chat_cubit.dart';
import 'package:messenger_mobile/core/utils/paginated_scroll_controller.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_view_model.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import 'package:messenger_mobile/modules/chats/presentation/widgets/categories_bloc_listener.dart';
import 'package:messenger_mobile/modules/chats/presentation/widgets/chat_item/chat_preview_item.dart';
import '../../../../locator.dart';
import '../bloc/cubit/chats_cubit_cubit.dart';


class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}


class _ChatsScreenState extends State<ChatsScreen> {

  PaginatedScrollController scrollController = PaginatedScrollController();
  ChatsCubit cubit;

  @override
  void initState() {
    cubit = sl<ChatsCubit>();
    context.read<ChatGlobalCubit>().loadChats(isPagination: false);
    scrollController.addListener(() {
      bool hasNextPage = context.read<ChatGlobalCubit>().state.chats?.paginationData?.hasNextPage ?? true;
      bool viewIsLoading = context.read<ChatGlobalCubit>().state is ChatLoading;

      if (scrollController.isPaginated && hasNextPage && !viewIsLoading) {
        context.read<ChatGlobalCubit>().loadChats(isPagination: true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatGlobalCubit, ChatState>(
      listener: (context, chatState) {
        _handleChatsUpdates(chatState);
      },
      builder: (context, chatState) {
        return BlocProvider<ChatsCubit>.value(
          value: cubit,
          child: BlocConsumer<ChatsCubit, ChatsCubitState>(
            cubit: cubit,
            listener: (context, state) {},
            builder: (context, state) {
              int chatsCount = chatState.chats?.data?.length ?? 0;

              return Scaffold(
                appBar: _buildAppBar(
                  cubit.selectedChat != null ?
                  ChatViewModel(cubit.selectedChat) : null,
                  () async {
                    final PickedFile image = await ImagePicker().getImage(source: ImageSource.gallery);
                    final file = File(image.path);
                    cubit.setWallpaper(file);
                  }
                ),
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: state.wallpaperFile != null ? 
                        FileImage(state.wallpaperFile) : 
                          AssetImage('assets/images/bg-home.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black87, BlendMode.lighten)
                    ) 
                  ),
                  child: ListView.separated(
                    controller: scrollController,
                    itemBuilder: (context, int index) {
                      if (index == 0) {
                        return ChatScreenCategoriesView(
                          chatsState: state,
                        );
                      } else if (index <= chatsCount) {
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
                    itemCount: chatState is ChatLoading ? 6 + chatsCount :
                      chatsCount + 1,
                    separatorBuilder: (context, int index) {
                      return _buildSeparators(index);
                    }
                  )
                )
              );
            }
          ),
        );
      },
    );
  }

  // * * Methods

  void _handleChatsUpdates (ChatState state) {
    if (state is ChatsError) {
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

  AppBar _buildAppBar (
    ChatViewModel selectedChat,
    Function onIconClick
  ) {
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
      actions: [
        IconButton(
          icon: Icon(Icons.format_paint),
          onPressed: () {
            onIconClick();
          }
        )
      ],
    );
  }
}



extension on _ChatsScreenState {

}