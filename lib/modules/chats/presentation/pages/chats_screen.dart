import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/image_text_view.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/blocs/chat/bloc/bloc/chat_cubit.dart';
import '../../../../core/utils/paginated_scroll_controller.dart';
import '../../../../core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/core/blocs/chat/bloc/bloc/chat_cubit.dart';
import 'package:messenger_mobile/core/utils/paginated_scroll_controller.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_view_model.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import 'package:messenger_mobile/modules/chats/presentation/widgets/categories_bloc_listener.dart';
import 'package:messenger_mobile/modules/chats/presentation/widgets/chat_item/chat_preview_item.dart';
import '../../../../locator.dart';
import '../../../category/data/models/chat_view_model.dart';

import '../bloc/cubit/chats_cubit_cubit.dart';
import '../widgets/categories_bloc_listener.dart';
import '../widgets/chat_item/chat_preview_item.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  PaginatedScrollController scrollController = PaginatedScrollController();
  ChatsCubit cubit;
  String language;

  @override
  void initState() {
    language = sl<SharedPreferences>().getString('language') ?? 'English';
    cubit = sl<ChatsCubit>();
    context.read<ChatGlobalCubit>().loadChats(isPagination: false);
    scrollController.addListener(() {
      bool hasNextPage = !context.read<ChatGlobalCubit>().state.hasReachedMax;
      bool viewIsLoading = context.read<ChatGlobalCubit>().state is ChatLoading;

      if (scrollController.isPaginated) {
        if (hasNextPage && !viewIsLoading) {
          context.read<ChatGlobalCubit>().loadChats(isPagination: true);
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
              int chatsCount = chatState.chats?.length ?? 0;

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
                  child: ListView.separated(
                    controller: scrollController,
                    itemBuilder: (context, int index) {
                      if (index == 0) {
                        return ChatScreenCategoriesView(
                          chatsState: state,
                        );
                      } else if (index <= (chatsCount == 0 && !(chatState is ChatLoading) ? 1 : chatsCount)) {
                        if (chatsCount != 0) {
                          return GestureDetector(
                            onLongPressStart: (d) {
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
                          return Center(child: EmptyView());
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
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content:
              Text(state.errorMessage, style: TextStyle(color: Colors.red)),
        ), // SnackBar
      );
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

  AppBar _buildAppBar(ChatViewModel selectedChat, Function onIconClick) {
    var isSelected = selectedChat != null;

    return AppBar(
      title: Text(!isSelected ? 'appBarTitle'.tr() : 'selectedChats'.tr()),
      leading: isSelected
        ? IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.read<ChatsCubit>().didCancelChatSelection();
            },
          )
        : null,
      actions: [
        DropdownButton(
          value: language,
          icon: Icon(Icons.language_outlined),
          iconSize: 24,
          elevation: 15,
          onChanged: (String newLanguage) async {
            setState(() => language = newLanguage);
          },
          items: <String>['English', 'Русский', 'Kazakh']
            .map<DropdownMenuItem<String>>(
              (String value) => DropdownMenuItem(
                child: Text(value),
                value: value,
                onTap: () async {
                  if (value == 'English') {
                    EasyLocalization.of(context)
                      .setLocale(Locale('en', 'US'));
                  } else if (value == 'Kazakh') {
                    EasyLocalization.of(context)
                      .setLocale(Locale('kk', 'KZ'));
                    ;
                  } else {
                    EasyLocalization.of(context)
                      .setLocale(Locale('ru', 'RU'));
                  }
                },
              ),
            )
            .toList(),
        ),
        IconButton(
          icon: Icon(Icons.format_paint),
          onPressed: () {
            onIconClick();
          },
        )
      ],
    );
  }
}

