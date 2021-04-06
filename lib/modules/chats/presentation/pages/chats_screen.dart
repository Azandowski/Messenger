import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../app/application.dart';
import '../../../../core/blocs/chat/bloc/bloc/chat_cubit.dart';
import '../../../../core/utils/paginated_scroll_controller.dart';
import '../../../../core/utils/snackbar_util.dart';
import '../../../../core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import '../../../../core/widgets/independent/small_widgets/image_text_view.dart';
import '../../../../locator.dart';
import '../../../category/data/models/chat_view_model.dart';
import '../../../chat/presentation/chats_screen/pages/chat_screen.dart';
import '../bloc/cubit/chats_cubit_cubit.dart';
import '../widgets/categories_bloc_listener.dart';
import '../widgets/chat_item/chat_preview_item.dart';
import 'chats_search_screen.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  
  PaginatedScrollController scrollController = PaginatedScrollController();
  ChatsCubit cubit;

  NavigatorState get _navigator => sl<Application>().navKey.currentState;

  @override
  void initState() {
    cubit = sl<ChatsCubit>();
    context.read<ChatGlobalCubit>().loadChats(isPagination: false);
    scrollController.addListener(() {
      bool hasNextPage = !context.read<ChatGlobalCubit>().state.hasReachedMax;
      bool viewIsLoading = context.read<ChatGlobalCubit>().state is ChatLoading;

      if (scrollController.isPaginated) {
        if (hasNextPage && !viewIsLoading) {
          context.read<ChatGlobalCubit>().loadChats(
            isPagination: true,
            categoryID: cubit.state.currentTabIndex == 0 ? null : cubit.state.currentTabIndex
          );
        }
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
    print(context.locale);
    return BlocConsumer<ChatGlobalCubit, ChatState>(
      listener: (context, chatState) {
        _handleChatsUpdates(chatState);
      },
      builder: (context, chatState) {
        return BlocProvider<ChatsCubit>.value(
          value: cubit,
          child: BlocConsumer<ChatsCubit, ChatsCubitState>(
            bloc: cubit,
            listener: (context, state) {},
            builder: (context, state) {
              int chatsCount = chatState.chats?.length ?? 0;

              return Scaffold(
                appBar: buildAppBar(context),
                body: Container(
                  child: ListView.separated(
                    controller: scrollController,
                    itemBuilder: (context, int index) {
                      if (index == 0) {
                        return ChatScreenCategoriesView(
                          chatsState: state,
                        );
                      } else if (index <= (chatsCount == 0 && !(chatState is ChatLoading) ? 1 : chatsCount)) {
                        if (chatsCount != 0) {
                          return InkWell(
                            onLongPress: () {
                              cubit.didSelectChat(index - 1);
                            },
                            onTap: () {
                              Navigator.push(
                                context, MaterialPageRoute(builder: (context) => ChatScreen(chatEntity: chatState.chats[index - 1],)),
                              );
                            },
                            child: ChatPreviewItem(
                              ChatViewModel(
                                chatState.chats[index - 1],
                                isSelected: cubit.selectedChatIndex != null 
                                  && cubit.selectedChatIndex == index - 1
                              )
                            ),
                          );
                        } else {
                          return Center(child: EmptyView(
                            text: 'no_chats_in_category'.tr(),
                          ));
                        }
                      } else {
                        return CellShimmerItem();
                      }
                    },
                    itemCount: chatState is ChatLoading ? 6 + chatsCount :
                      chatsCount == 0 ? 2 : chatsCount + 1,
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

  void _handleChatsUpdates(ChatState state) {
    if (state is ChatsError) {
      SnackUtil.showError(context: context, message: state.errorMessage);
    }
  }

  Widget _buildSeparators(int index) {
    if (index == 0) {
      return Container();
    } else {
      return Container(
        height: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Divider(
          color: Colors.grey,
        ),
      );
    }
  } 

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text('chats'.tr()),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            _navigator.push(ChatsSearchScreen.route());
            // ChatsSearchScreen
          },
        )
        // searchBar.getSearchAction(context)
      ]
    );
  }
}

